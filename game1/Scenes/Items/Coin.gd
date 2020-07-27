extends RigidBody2D


var detected
var target
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	apply_impulse(Vector2(), Vector2(rng.randf_range(-20,20),-40))

func _integrate_forces(state):
	if detected:
		set_linear_velocity(140*(target.position - position).normalized())


func magnet(target_body):
	detected = true
	target = target_body
	set_collision_mask_bit(1, false)
