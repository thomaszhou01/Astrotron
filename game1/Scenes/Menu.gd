extends "res://Scenes/mainScript.gd"



export (bool) var devMode
var x

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_TextureButton_pressed():
	$AnimationPlayer.play("ToMapSelect")


func _on_map1_pressed():
	$Tween.interpolate_property($MenuMusic, "volume_db", -5, -20, 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.start()
	if devMode:
		x = test.instance()
	else:
		x = map1.instance()
	SceneTransition.fadeIn()
	yield(get_tree().create_timer(1), "timeout")
	get_parent().get_node("Worlds").add_child(x)
	queue_free()
	SceneTransition.fadeOut()
