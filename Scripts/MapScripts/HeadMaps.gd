extends Node2D

var player : Player

func startMap():
	player = $Player
	player.get_node("Sprite").modulate = Color.WHITE
	var ShaderMat = ShaderMaterial.new()
	ShaderMat.shader = load("res://Shaders/WhitePlayer.gdshader")
	player.get_node("Sprite").material = ShaderMat
	
	SoundHandler.play_sound($Sounds/RedPillarsIntroSong)
	SoundHandler.tween_sound($Sounds/RedPillarsIntroSong, 1.0, 1.0)
