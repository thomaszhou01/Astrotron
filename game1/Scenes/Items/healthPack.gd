extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_healthPack_body_entered(body):
	if body.has_method("heal"):
		body.heal(health)
		queue_free()
	

