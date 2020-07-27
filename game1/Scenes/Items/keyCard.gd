extends Area2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_keyCard_body_entered(body):
	if "Character" in body.name:
		Global.hasKey = true
		queue_free()
