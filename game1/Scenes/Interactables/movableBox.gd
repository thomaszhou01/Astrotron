extends RigidBody2D


export (int) var maxHP
var hp
var rng = RandomNumberGenerator.new()
var pieces = preload("res://Scenes/Interactables/woodPieces.tscn")
var pieces_instance
var knockback = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = maxHP


func hit(damage, hitBy, knock, type):
	hp -= damage
	if hp <= 0:
		rng.randomize()
		for i in range(0, rng.randi_range(1, 3)):
			pieces_instance = pieces.instance()
			get_parent().call_deferred("add_child", pieces_instance)
			rng.randomize()
			pieces_instance.position.x = position.x + rng.randi_range(-10,10)
			rng.randomize()
			pieces_instance.position.y = position.y + rng.randi_range(-15,10)
			if type == 0:
				pieces_instance.apply_impulse(Vector2(), Vector2(rng.randf_range(-20,20),-30))
			elif type == 1:
				pieces_instance.apply_impulse(Vector2(), Vector2(rng.randf_range(100,150) * (position - hitBy.position).normalized()))
			rng.randomize()
			pieces_instance.set_angular_velocity(rng.randf_range(-40,40))
		queue_free()
	
	if float(hp)/maxHP <= 0.25:
		$Sprite.frame = 2
	elif float(hp)/maxHP <= 0.5:
		$Sprite.frame = 1
