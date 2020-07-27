extends Area2D

export (String) var message

func _ready():
	$Node2D/Label.text = message
	$Node2D/Label.visible_characters = 0

func _on_Timer_timeout():
	$Node2D/Label.visible_characters += 1



func _on_DisplayTextArea_body_entered(body):
	if body.name == "Character":
		$Timer.start()

