extends ColorRect

var loaded = false

var cd = false

func _ready():
	$NewGameButton.grab_focus()

func _on_new_game_button_focus_entered():
	if loaded:
		$MoveSound.play()
	loaded = true

func _on_load_game_button_focus_entered():
	$MoveSound.play()

func loadGame():
	cd = true
	$EnterSound.play()
	$NewGameButton.release_focus()
	
	await Global.transitionTo(Color(0, 0, 0, 1), 3.0, true)
	Global.wait(1)
	
	var modTween = get_tree().create_tween()
	modTween.tween_property(get_tree().root.get_node("GlobalUI/CautionText"), "modulate", Color(1, 1, 1, 1), 2.0)
	await modTween.finished
	Global.wait(4)
	
	var modTween2 = get_tree().create_tween()
	modTween2.tween_property(get_tree().root.get_node("GlobalUI/CautionText"), "modulate", Color(1, 1, 1, 0), 2.0)
	await modTween2.finished
	
	Global.toScene("res://Scenes/Maps/HeadWorld/ExitComa.tscn", 2.0, 2.0, Vector2i(288, 1008))

func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		if get_viewport().gui_get_focus_owner() == null: return
		if get_viewport().gui_get_focus_owner().name == "NewGameButton" and !cd: # Starts a new game
			loadGame()
