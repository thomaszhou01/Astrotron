extends Area2D	


var speed
var direction
var damage
var spin
var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start(dir, dmg, sprite, spd, rotate, mobCollide, playerCollide):
	damage = dmg
	direction = dir 
	rotation = dir.angle()
	speed = spd
	velocity = dir * speed
	$Sprite.set_frame(sprite)
	spin = rotate
	self.set_collision_mask_bit(3, mobCollide)
	self.set_collision_mask_bit(0, playerCollide)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity*delta
	if spin:
		$Sprite.rotate(1)


func _on_bullet_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage, self, true, 0)
	queue_free()
