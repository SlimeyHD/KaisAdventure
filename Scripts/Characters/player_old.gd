extends CharacterBody2D

@onready var animationPlayer = $AnimationPlayer
@onready var CollisionRay = $CollisionRay
@onready var InteractableRay = $InteractableRay

@export var walkingSpeed = 1.0

var WalkPixelAmount = 32
var finishedOneTile = true
var isPressingWASD = false

var walkDirection

func zoomTo(factor):
	var CamTween = get_tree().create_tween()
	CamTween.tween_property($Camera2DPlus, "zoom", Vector2(factor, factor), 1)

func lookTo(direction):
	CollisionRay.target_position = direction[1] * WalkPixelAmount
	CollisionRay.force_raycast_update()
	animationPlayer.play("idle"+direction[0]+"_anim")

func updateDirection():
	for i in GlobalVariables.buttons.size():
		if Input.is_action_pressed("walk"+GlobalVariables.buttons[i][0]):
			isPressingWASD = true
			walkDirection = GlobalVariables.buttons[i]
			return
	isPressingWASD = false

func zoneCheck():
	if $Area2D.get_overlapping_areas() != [] and $Area2D.get_overlapping_areas()[0].name == "ZoneArea":
		var ZoneArea = $Area2D.get_overlapping_areas()[0].get_parent()
		Global.toScene(ZoneArea.zone, ZoneArea.tween_time, ZoneArea.wait_time, ZoneArea.playerPos, ZoneArea.lookDirection)

func pressedAcceptButton():
	if finishedOneTile:
		InteractableRay.target_position = walkDirection[1] * WalkPixelAmount
		InteractableRay.force_raycast_update()
		if !GlobalVariables.isLoading and GlobalVariables.canInteract and InteractableRay.is_colliding() and InteractableRay.get_collider().name == "InteractableObject":
			MessageHandler.createMessage(InteractableRay.get_collider().get_parent())

func _input(_event):
	if Input.is_action_just_pressed("accept"): pressedAcceptButton()

func _physics_process(_delta):
	await updateDirection() # Updates the way the player is moving to
	if finishedOneTile: # If player finished moving a tile
		if isPressingWASD and !GlobalVariables.isTalking and !GlobalVariables.isLoading: # If player is holding WASD and isnt talking / loading
			CollisionRay.target_position = walkDirection[1] * WalkPixelAmount
			CollisionRay.force_raycast_update()
			if !CollisionRay.is_colliding(): # If player isnt walking into a wall
				finishedOneTile = false
				var tweenTime = 0.25 / walkingSpeed
				var tween = get_tree().create_tween()
				tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
				tween.tween_property(self, "position", (((self.position)/WalkPixelAmount + walkDirection[1]).floor() * WalkPixelAmount) + Vector2(16, 4), tweenTime)
				animationPlayer.play("walk"+walkDirection[0]+"_anim", -1, walkingSpeed)
				await tween.finished
				zoneCheck()
				finishedOneTile = true
			else: # If player is walking into a wall
				animationPlayer.play("idle"+walkDirection[0]+"_anim", -1, walkingSpeed)
		else: # If player is not holding WASD or is talking / loading
			animationPlayer.stop()
