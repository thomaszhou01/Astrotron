extends RigidBody2D


var speed
var direction
var damage
var spin
var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start(dir, dmg, sprite, spd, rotate):
	damage = dmg
	direction = dir 
	speed = spd
	velocity = dir * speed
	$AnimatedSprite.play("bomb")
	spin = rotate

func shoot():
	$Timer.autostart = true
	self.apply_impulse(Vector2(0,0), velocity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $AnimatedSprite.get_frame() == 8:
		queue_free()
	


func _on_Timer_timeout():
	$Area2D/HurtBox.disabled = false
	$AnimatedSprite.play("explosion")



func _on_Area2D_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage, self.global_position.x, true)
