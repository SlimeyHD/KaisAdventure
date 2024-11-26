extends Node

@onready var root = get_tree().root

var player = preload("res://Scenes/Characters/player.tscn")

var GlobalUI
var TransitionRect
var Controls = load("res://Scenes/UI/control.tscn").instantiate()

var left_rect = null

var directions = {
	"left" = Vector2(-1, 0),
	"right" = Vector2(1, 0),
	"up" = Vector2(0, 1),
	"down" = Vector2(0, -1),
}

func wait(time : float):
	await get_tree().create_timer(time).timeout

func transitionTo(transitionToColor : Color, tween_time = 1.0):
	var tween = get_tree().root.create_tween()
	tween.tween_property(TransitionRect, "color", transitionToColor, tween_time)
	
	await tween.finished

func toScene(path, tween_time = 1.0, wait_time = 1.0, playerPos = Vector2i(0, 0), lookDirection = "down", changeTransition = true):
	call_deferred("_deferred_goto_scene", path, tween_time, wait_time, playerPos, lookDirection, changeTransition)

func _deferred_goto_scene(path, tween_time, wait_time, playerPos, lookDirection, changeTransition):
	GlobalVar.isLoading = true
	if changeTransition: await transitionTo(Color("BLACK"), tween_time)
	
	var currentScene := get_tree().current_scene
	currentScene.call_deferred("free")
	
	if typeof(path) == 24: #Int type of Resource type
		path = path.resource_path
	
	var scene = load(path)
	currentScene = scene.instantiate()
	
	await wait(wait_time)
	
	get_tree().root.add_child(currentScene)
	get_tree().current_scene = currentScene
	
	var playerNode = player.instantiate()
	currentScene.add_child(playerNode)
	
	playerNode.position = Vector2i(floor(playerPos.x/32)*32 + 16, floor(playerPos.y/32)*32 + 4)
	playerNode.lookTo(directions[lookDirection])
	
	var SceneCam : Camera2DPlus = get_tree().current_scene.get_node("Camera")
	SceneCam.set_follow_node(playerNode)
	
	if currentScene.has_method("startMap") : currentScene.startMap()
	
	if changeTransition: await transitionTo(Color("TRANSPARENT"), tween_time)
	
	GlobalVar.isLoading = false
