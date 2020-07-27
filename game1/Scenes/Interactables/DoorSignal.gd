extends Area2D


export (bool) var open
var used 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_DoorSignal_body_entered(body):
	if body.name == "Character" && !used:
		used = true
		if open:
			get_parent().get_node("AnimationPlayer").play("open")
		else:
			get_parent().get_node("AnimationPlayer").play("close")
