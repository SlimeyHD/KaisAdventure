extends Node2D

func _ready():
	await Global.wait(3)
	Message.addText("HELO :D ;I am gay! ;WHAT THE FUCK OK NOOOOO STOP YOU MOTHEERFUCKER AHHHHHHHHHH WTFFFFFFFFFFFFF")
	Message.addText("Actually hmm no I dont have regrets ;probably")
	Message.addText("Sigh idk what im talking abt; no really :sob:; please dont hate me omg plessss WAA")
	Message.addText("Wait no I am sorry :sob:")
	await Message.startDialogue()
	
	print("Done real")
	
	await Global.wait(5)
	
	Message.addText("Hah, i trolled you.; [font_size={14}]also hi dave[/font_size]")
	Message.startDialogue()
	
