extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_TextureButton_pressed():
	var map = load("res://Scenes/Menu.tscn").instance()
	SceneTransition.fadeIn()
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
	get_parent().add_child(map)
	SceneTransition.fadeOut()
