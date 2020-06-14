extends Area2D	


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
	rotation = dir.angle()
	speed = spd
	velocity = dir * speed
	$Sprite.set_frame(sprite)
	spin = rotate


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity*delta
	if spin:
		$Sprite.rotate(1)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_bullet_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage, self.global_position.x, true)
	queue_free()
