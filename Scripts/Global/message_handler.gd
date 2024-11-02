extends Node

# Variables #
@onready var root = get_tree().root

var Canvas
var TextBox
var TextLabel

var CharacterTextPlaceholder

var currentInstance = null

var currentText = 0
var currentMultText = 0

var isTalkingLocal = false
var isDoneReading = false
var hasMultipleLines = false

var TweenRunning

var cd = false

# Functions #
func _ready():
	var create_nodes = get_node("/root/CreateNodes")
	create_nodes.connect("sendGlobalUI", _startScript)

func _startScript(CanvasTemp):
	Canvas = CanvasTemp
	TextBox = Canvas.get_node("TextBox")
	TextLabel = TextBox.get_node("TextLabel")
	while true:
		if TextLabel.text.length() != 0 and TextLabel.visible_characters > lastCharacters:
			if TextLabel.text.unicode_at(TextLabel.visible_characters) != 0 and TextLabel.text[TextLabel.visible_characters] != " ":
				TextBox.get_node("TextSound").play()
		lastCharacters = TextLabel.visible_characters
		await get_tree().create_timer(0.01).timeout

var lastCharacters = 0

func _input(_event):
	if Input.is_action_just_pressed("accept") and cd == false:
		cd = true
		if isTalkingLocal:
			if !isDoneReading and TweenRunning != null:
				TweenRunning.kill()
				TextLabel.visible_ratio = 1
				isDoneReading = true
			elif isDoneReading:
				if !hasMultipleLines: currentText += 1
				else: currentMultText += 1
				if currentText < currentInstance.TextArray.size():
					if typeof(currentInstance.TextArray[currentText]) == TYPE_PACKED_STRING_ARRAY:
						DisplayMultipleText()
					else:
						DisplayText()
				else:
					closeTextBox()
		await get_tree().create_timer(0.02).timeout
		cd = false

func createMessage(InteractableBox):
	currentInstance = InteractableBox
	currentText = 0
	GlobalVariables.canInteract = false
	GlobalVariables.isTalking = true
	isTalkingLocal = true
	#Open Text Box
	var OpenTextBox = root.create_tween()
	OpenTextBox.tween_property(TextBox, "scale", Vector2(1, 1), 0.1)
	await OpenTextBox.finished
	#Displays Text
	
	if typeof(currentInstance.TextArray[currentText]) == TYPE_PACKED_STRING_ARRAY:
		DisplayMultipleText()
	else:
		DisplayText()

func closeTextBox():
	var CloseTextBox = root.create_tween()
	CloseTextBox.tween_property(TextBox, "scale", Vector2(0, 1), 0.1)
	await CloseTextBox.finished
	GlobalVariables.isTalking = false
	isTalkingLocal = false
	isDoneReading = false
	TextLabel.text = ""
	TextLabel.visible_ratio = 0
	await get_tree().create_timer(0.5).timeout
	GlobalVariables.canInteract = true

func DisplayText():
	isDoneReading = false
	TextLabel.visible_ratio = 0
	TextLabel.text = currentInstance.TextArray[currentText]
	var CharacterScrollingSpeed = (TextLabel.get_total_character_count()/20.0)/int(currentInstance.TextSpeed[currentText])
	TweenRunning = root.create_tween()
	TweenRunning.tween_property(TextLabel, "visible_ratio", 1, CharacterScrollingSpeed)
	await TweenRunning.finished
	
	isDoneReading = true

func DisplayMultipleText():
	if currentMultText < currentInstance.TextArray[currentText].size():
		isDoneReading = false
		hasMultipleLines = true
		if currentMultText == 0:
			TextLabel.visible_ratio = 0
			TextLabel.text = ""
			TextLabel.text += currentInstance.TextArray[currentText][currentMultText]
		else:
			TextLabel.text += currentInstance.TextArray[currentText][currentMultText]
			TextLabel.visible_characters = (TextLabel.get_total_character_count() - currentInstance.TextArray[currentText][currentMultText].length())
		var CharacterScrollingSpeed = ((currentInstance.TextArray[currentText][currentMultText].length())/20.0)/int(currentInstance.TextSpeed[currentText])
		TweenRunning = root.create_tween()
		TweenRunning.tween_property(TextLabel, "visible_ratio", 1, CharacterScrollingSpeed)
		await TweenRunning.finished
		
		isDoneReading = true
	else:
		hasMultipleLines = false
		currentMultText = 0
		currentText += 1
		if currentText < currentInstance.TextArray.size():
			DisplayText()
		else:
			closeTextBox()
