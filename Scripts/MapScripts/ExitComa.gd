extends Node2D

@onready var root = get_tree().root

func _ready():
	root.get_node("Backgrounds/ComaAreaBackground2").show()
