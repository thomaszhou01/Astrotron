extends Area2D	


const speed = 300
var direction
var damage
var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start(dir, dmg, sprite):
	damage = dmg
	direction = dir 
	rotation = dir.angle()
	velocity = dir * speed
	$Sprite.set_frame(sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity*delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_bullet_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage)
	queue_free()
