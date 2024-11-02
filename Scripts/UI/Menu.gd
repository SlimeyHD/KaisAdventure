extends Control

signal pressedAccept

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

func _input(_event):
	if Input.is_action_just_pressed("accept"):
		if get_viewport().gui_get_focus_owner() == null: return
		if get_viewport().gui_get_focus_owner().name == "NewGameButton" and !cd: # Starts a new game
			cd = true
			$EnterSound.play()
			$NewGameButton.release_focus()
			await Global.transitionTo(Color(0, 0, 0, 1), 3.0, true)
			await get_tree().create_timer(1.0).timeout
			var modTween = get_tree().create_tween()
			modTween.tween_property(get_tree().root.get_node("GlobalUI/CautionText"), "modulate", Color(1, 1, 1, 1), 2.0)
			await modTween.finished
			await get_tree().create_timer(4.0).timeout
			var modTween2 = get_tree().create_tween()
			modTween2.tween_property(get_tree().root.get_node("GlobalUI/CautionText"), "modulate", Color(1, 1, 1, 0), 2.0)
			await modTween2.finished
			Global.toScene("res://Scenes/Maps/HeadWorld/ExitComa.tscn", 2.0, 2.0, Vector2i(288, 1008))
