extends Node

@onready var root = get_tree().root

var GlobalUI
var TransitionRect
var Controls = load("res://Scenes/UI/control.tscn").instantiate()

var currentScene = null
var left_rect = null

var directions = {
	"left" = Vector2(-1, 0),
	"right" = Vector2(1, 0),
	"up" = Vector2(0, 1),
	"down" = Vector2(0, -1),
}

func wait(time : float):
	await get_tree().create_timer(time).timeout

func transitionTo(transitionToColor = Color(0, 0, 0, 1), tween_time = 1.0, waitForEnd = true):
	var tween = get_tree().root.create_tween()
	tween.tween_property(TransitionRect, "color", transitionToColor, tween_time)
	
	if waitForEnd == true:
		await tween.finished

func toScene(path, tween_time = 1.0, wait_time = 1.0, playerPos = Vector2i(0, 0), lookDirection = "down", changeTransition = true):
	call_deferred("_deferred_goto_scene", path, tween_time, wait_time, playerPos, lookDirection, changeTransition)

func _deferred_goto_scene(path, tween_time, wait_time, playerPos, lookDirection, changeTransition):
	if typeof(path) == 24: #Int type of Resource type
		path = path.resource_path
	
	GlobalVar.isLoading = true
	GlobalVar.canInteract = false
	
	if changeTransition:
		await transitionTo(Color(0, 0, 0, 1), tween_time, true)
	
	currentScene = get_tree().current_scene
	currentScene.call_deferred("free")
	
	var scene = ResourceLoader.load(path)
	
	currentScene = scene.instantiate()
	
	if currentScene.has_method("StartMap"): await currentScene.StartMap()
	
	wait(wait_time)
	get_tree().root.add_child(currentScene)
	get_tree().current_scene = currentScene
	
	currentScene.get_node("Player").position = Vector2i(floor(playerPos.x/32)*32 + 16, floor(playerPos.y/32)*32 + 4)
	currentScene.get_node("Player").lookTo(directions[lookDirection])
	
	if changeTransition:
		await transitionTo(Color(0, 0, 0, 0), tween_time, true)
	
	GlobalVar.isLoading = false
	GlobalVar.canInteract = true
