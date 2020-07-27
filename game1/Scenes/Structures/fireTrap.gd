extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var damage

# Called when the node enters the scene tree for the first time.
func _ready():
	damage = 1000000



func _on_Area2D_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage, self.global_position.x, true)
