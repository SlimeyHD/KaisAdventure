extends Node2D

@export var zone : PackedScene
@export var wait_time := 0.5
@export var tween_time := 0.5
@export var playerPos := Vector2i(0, 0)
@export_enum("left", "right", "up", "down") var lookDirection = "down"
