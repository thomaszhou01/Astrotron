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
	speed = 100
	velocity = dir * speed
	$Sprite.set_frame(sprite)
	spin = rotate

func shoot():
	$Timer.autostart = true
	self.apply_impulse(Vector2(0,0), velocity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()



func _on_grenade_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage, self.global_position.x, true)
		print("yep")
	queue_free()


func _on_Timer_timeout():
	$Area2D/HurtBox.disabled = false



func _on_Area2D_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage, self.global_position.x, true)
	queue_free()
