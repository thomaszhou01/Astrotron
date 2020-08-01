extends Area2D	


var speed
var direction
var damage
var spin
var propell
var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	propell = true

func start(dir, dmg, sprite, spd, rotate, mobCollide, playerCollide):
	damage = dmg
	direction = dir 
	rotation = dir.angle()
	speed = spd
	velocity = dir * speed
	spin = rotate
	self.set_collision_mask_bit(3, mobCollide)
	self.set_collision_mask_bit(0, playerCollide)
	$AnimatedSprite.play("rocket")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $AnimatedSprite.get_frame() == 8:
		$AnimatedSprite.visible = false
		$Particles2D.visible = false
		$Area2D/HurtBox.disabled = true
	if propell:
		position += velocity*delta
	$Particles2D.emitting = true
	
	if spin:
		$AnimatedSprite.rotate(1)


func _on_rocket_body_entered(body):
	if propell:
		$audio.play()
	$Timer.start()
	$AnimatedSprite.play("explosion")
	$AnimatedSprite.scale.x = 0.5
	$AnimatedSprite.scale.y = 0.5
	propell = false


func _on_Area2D_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage, self, true, 1)


func _on_Timer_timeout():
	$Area2D/HurtBox.disabled = false


func _on_audio_finished():
	queue_free()
