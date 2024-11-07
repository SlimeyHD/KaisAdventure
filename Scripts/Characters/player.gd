extends CharacterBody2D

@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var InteractableRay = $InteractableRay

@export var walkingSpeed = 1.0

var WalkPixelAmount = 32
var input_direction = Vector2()

func zoomTo(factor):
	var CamTween = get_tree().create_tween()
	CamTween.tween_property($Camera2DPlus, "zoom", Vector2(factor, factor), 1)

func lookTo(direction):
	animationTree.set("parameters/Idle/blend_position", direction)

func zoneCheck():
	if $Area2D.get_overlapping_areas() != [] and $Area2D.get_overlapping_areas()[0].name == "ZoneArea":
		var ZoneArea = $Area2D.get_overlapping_areas()[0].get_parent()
		Global.toScene(ZoneArea.zone, ZoneArea.tween_time, ZoneArea.wait_time, ZoneArea.playerPos, ZoneArea.lookDirection)

func pressedAcceptButton():
	if !GlobalVariables.isLoading and GlobalVariables.canInteract and InteractableRay.is_colliding() and InteractableRay.get_collider().name == "InteractableObject":
		MessageHandler.createMessage(InteractableRay.get_collider().get_parent())

func pressedChangeWorldButton():
	if !GlobalVariables.isChangingWorld and !GlobalVariables.isLoading and GlobalVariables.canInteract:
		GlobalVariables.isChangingWorld = true
		await Global.transitionTo(Color(0, 0, 0, 1), 0.5, true)
		GlobalVariables.isDreamWorld = !GlobalVariables.isDreamWorld
		
		await get_tree().create_timer(0.5).timeout
		await Global.transitionTo(Color(0, 0, 0, 0), 0.5, true)
		GlobalVariables.isChangingWorld = false

func _input(_event):
	if Input.is_action_just_pressed("accept"): pressedAcceptButton()
	if Input.is_action_just_pressed("changeWorld"): pressedChangeWorldButton()

func _physics_process(_delta):
	if !GlobalVariables.isLoading: zoneCheck()
	input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_direction != Vector2.ZERO and !GlobalVariables.isTalking and !GlobalVariables.isLoading and !GlobalVariables.isChangingWorld:
		animationTree.set("parameters/Walk/blend_position", input_direction)
		animationTree.set("parameters/Idle/blend_position", input_direction)
		animationState.travel("Walk")
		velocity = input_direction * 100 * walkingSpeed
		move_and_slide()
	else:
		animationState.travel("Idle")
