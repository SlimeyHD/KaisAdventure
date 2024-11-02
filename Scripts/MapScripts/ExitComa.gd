extends Node2D

@onready var root = get_tree().root

func _ready():
	await get_tree().create_timer(4).timeout
	root.get_node("Backgrounds/ComaAreaBackground2").show()
