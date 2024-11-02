extends Node2D

@export var TextArray = ["TEMPLATE"]
@export var TextSpeed = [1.0]
@export var DefaultSpeed = 1.0

func _ready():
	TextSpeed.resize(TextArray.size())
	for i in TextArray.size():
		if TextSpeed[i] == null: TextSpeed[i] = DefaultSpeed
		if TextArray[i].find(";") != -1:
			TextArray[i] = TextArray[i].split(";")
