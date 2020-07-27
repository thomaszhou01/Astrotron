extends RigidBody2D


export (int) var maxHP
export (int) var damage
var hp
var primed 


# Called when the node enters the scene tree for the first time.
func _ready():
	hp = maxHP

func _process(delta):
	if $AnimatedSprite.get_frame() == 8:
		queue_free()

func hit(damage, hitBy, knock, type):
	hp -= damage
	if hp <= 0 && !primed:
		$Timer.start()
		$Particles2D.emitting = true
		primed = true


func _on_Area2D_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage, self, true, 1)


func _on_Timer_timeout():
	$AnimatedSprite.scale.x = ($Area2D/CollisionShape2D.shape.radius * 2)/70
	$AnimatedSprite.scale.y = $AnimatedSprite.scale.x
	$Area2D/CollisionShape2D.disabled = false
	$AnimatedSprite.play("explosion")

