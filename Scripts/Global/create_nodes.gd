extends Node

signal sendGlobalUI

@onready var root = get_tree().root
var GlobalUI = load("res://Scenes/UI/GlobalUI.tscn").instantiate()
var Backgrounds = load("res://Scenes/UI/Backgrounds.tscn").instantiate()

func _ready():
	root.call_deferred("add_child", GlobalUI)
	root.call_deferred("add_child", Backgrounds)
	await GlobalUI.ready
	emit_signal("sendGlobalUI", GlobalUI)
