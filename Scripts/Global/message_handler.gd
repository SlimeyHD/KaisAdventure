extends Node

signal acceptPressed

#region # Variables #
@onready var root = get_tree().root

@onready var TextBox : Control
@onready var TextLabel : RichTextLabel

var textQueue : Array[PackedStringArray]

var isGeneratingText = false
var openedTextBox = false
var skipToEnd = false # If this is true, the displayed text will be fully visible instantly

#endregion

#region # Local Functions #
func _openTextBox():
	if openedTextBox == true: print("TextBox already opened!"); return
	openedTextBox = true
	
	var OpenTextBox = root.create_tween()
	OpenTextBox.tween_property(TextBox, "scale", Vector2(1, 1), 0.1)
	await OpenTextBox.finished

func _closeTextBox():
	if openedTextBox == false: print("TextBox already closed!"); return
	openedTextBox = false
	
	var CloseTextBox = root.create_tween()
	CloseTextBox.tween_property(TextBox, "scale", Vector2(0, 1), 0.1)
	await CloseTextBox.finished

func _displayNewText():
	var TextArray = textQueue[0] # This is the entire message that will be displayed
	
	for SplitMessage : String in TextArray: # Iterates each time the Split is done and player pressed accept
		TextLabel.text += SplitMessage
		isGeneratingText = true
		
		for letter : String in SplitMessage: # Iterates very quickly every letter
			if skipToEnd: # If the player has pressed "accept" while the text was still generating
				skipToEnd = false
				TextLabel.visible_characters = TextLabel.text.length()
				break
			
			TextLabel.visible_characters += 1
			
			if letter == " ": continue
			
			TextBox.get_node("TextSound").play()
			
			await Global.wait(0.04)
		
		isGeneratingText = false
		await acceptPressed
	
	TextLabel.text = ""
	TextLabel.visible_characters = 0
	textQueue.remove_at(0)

#endregion

#region # Functions #
func addText(text : String):
	if text != "":
		var textArray = text.split(";")
		textQueue.append(textArray)

func startDialogue(canWalk : bool = false):
	if openedTextBox: print("Character is already talking!"); return
	if textQueue.size() == 0: print("Text Queue is empty!"); return
	GlobalVar.canWalk = canWalk
	
	_openTextBox()
	
	while textQueue.size() >= 1:
		await _displayNewText()
		
	await _closeTextBox()
	GlobalVar.canWalk = true
#endregion

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("accept", true) and event.is_action("accept"):
		print("Pressed Accept")
		if isGeneratingText:
			skipToEnd = true
		emit_signal("acceptPressed")
