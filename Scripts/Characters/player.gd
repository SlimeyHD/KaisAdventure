extends CharacterBody2D
class_name Player

@onready var animationState = $AnimationTree.get("parameters/playback")
@onready var InteractableRay = $InteractableRay

@onready var AreaCollisionDetector = $AreaCollisionDetector

@export var walkingSpeed = 100.0

var WalkPixelAmount = 32
var input_direction = Vector2()

func zoomTo(factor):
	var CamTween = get_tree().create_tween()
	CamTween.tween_property($Camera2DPlus, "zoom", Vector2(factor, factor), 1)

func lookTo(direction):
	$AnimationTree.set("parameters/Idle/blend_position", direction)

func zoneCheck():
	if AreaCollisionDetector.get_overlapping_areas() == []: return
	if AreaCollisionDetector.get_overlapping_areas()[0].name == "ZoneArea":
		var ZoneArea = AreaCollisionDetector.get_overlapping_areas()[0].get_parent()
		Global.toScene(ZoneArea.zone, ZoneArea.tween_time, ZoneArea.wait_time, ZoneArea.playerPos, ZoneArea.lookDirection)

func startObjectDialogue():
	if !Message.openedTextBox and InteractableRay.get_collider() != null and InteractableRay.get_collider().name == "InteractableObject":
		Message.addText(InteractableRay.get_collider().get_parent())
		Message.startDialogue()

"""
func pressedChangeWorldButton():
	if !GlobalVar.isChangingWorld and !GlobalVar.isLoading and GlobalVar.canInteract:
		GlobalVar.isChangingWorld = true
		await Global.transitionTo(0.5 , Color(0, 0, 0, 1))
		GlobalVar.isDreamWorld = !GlobalVar.isDreamWorld
		
		await get_tree().create_timer(0.5).timeout
		await Global.transitionTo(0.5 , Color(0, 0, 0, 0))
		GlobalVar.isChangingWorld = false
"""

func _input(_event):
	if Input.is_action_just_pressed("ui_accept"): startObjectDialogue()
	#if Input.is_action_just_pressed("changeWorld"): pressedChangeWorldButton()

func _physics_process(_delta):
	if !GlobalVar.isLoading: zoneCheck()
	input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_direction != Vector2.ZERO and GlobalVar.canWalk:
		$AnimationTree.set("parameters/Walk/blend_position", input_direction)
		$AnimationTree.set("parameters/Idle/blend_position", input_direction)
		animationState.travel("Walk")
		velocity = input_direction * walkingSpeed
		move_and_slide()
	else:
		animationState.travel("Idle")
