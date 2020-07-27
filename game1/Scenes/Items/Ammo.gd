extends RigidBody2D

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	apply_impulse(Vector2(), Vector2(rng.randf_range(-20,20),-40))

func hasAmmo():
	pass
