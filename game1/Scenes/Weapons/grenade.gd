extends RigidBody2D


var speed
var direction
var damage
var spin
var propell
var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	propell = true

func start(dir, dmg, sprite, spd, rotate):
	damage = dmg
	direction = dir 
	speed = spd
	velocity = dir * speed
	$AnimatedSprite.play("bomb")
	spin = rotate
	$AnimatedSprite.set_rotation(direction.angle()-PI/2)

func shoot():
	self.apply_impulse(Vector2(0,0), velocity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $AnimatedSprite.get_frame() == 8:
		$AnimatedSprite.visible = false
		$Area2D/HurtBox.disabled = true
	$AnimatedSprite.set_rotation(get_linear_velocity().angle()-PI/2)

func _integrate_forces(state):
	if !propell:
		set_linear_velocity(Vector2(0,0))


func _on_Timer_timeout():
	$Area2D/HurtBox.disabled = false



func _on_Area2D_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage, self, true, 1)



func _on_BodyEntered_body_entered(body):
	if propell:
		$audio.play()
	$AnimatedSprite.play("explosion")
	$Timer.start()
	propell = false


func _on_audio_finished():
	queue_free()
