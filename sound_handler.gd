extends Node

var currentAudioPlaying : AudioStreamPlayer

func play_sound(sound : AudioStreamPlayer):
	if currentAudioPlaying == null: return
	
	if !currentAudioPlaying.playing and currentAudioPlaying != sound:
		currentAudioPlaying = sound
		currentAudioPlaying.play()
	else:
		print("Sound is already playing!")

func tween_sound(sound : AudioStreamPlayer, tweenTime = 1.0, tweenValue = 0.0):
	var tween = get_tree().root.create_tween()
	tween.tween_property(sound, "volume_db", linear_to_db(tweenValue), tweenTime)
	
	await tween.finished
