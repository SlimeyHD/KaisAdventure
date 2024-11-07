extends Node

# Variables #
@onready var root = get_tree().root

var GlobalUI = load("res://Scenes/UI/GlobalUI.tscn").instantiate()
var Backgrounds = load("res://Scenes/UI/Backgrounds.tscn").instantiate()

func _ready():
	# Adding Children Into Root
	root.call_deferred("add_child", GlobalUI)
	root.call_deferred("add_child", Backgrounds)
	
	await GlobalUI.ready
	
	# Setting Variables of other scripts
	Global.GlobalUI = GlobalUI
	Global.TransitionRect = GlobalUI.get_node("TransitionRect")
	
	MessageHandler.Canvas = GlobalUI
	MessageHandler.TextBox = GlobalUI.get_node("TextBox")
	MessageHandler.TextLabel = GlobalUI.get_node("TextBox").get_node("TextLabel")
