extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		

func sceneChange():
	pass

#	pass
func reset():
	get_tree().reload_current_scene()
