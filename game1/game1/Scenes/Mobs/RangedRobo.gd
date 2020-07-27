extends KinematicBody2D

const gravity = 50
const speed = 60
const FLOOR = Vector2(0, -1)
var bullet = preload("res://Scenes/bullet.tscn")
var velocity = Vector2();
var direction = 1
var hp
var target = null
var damage
var bulletSprite
var canShoot = false
var fire = true
var is_dead = false 
# Called when the node enters the scene tree for the first time.

func _ready():
	hp = 100
	damage = 20
	bulletSprite = 0

func hit(damage):
	hp -= damage
	if hp <=0:
		dead()

func dead(): 
	is_dead = true
	velocity = Vector2(0,0)
	canShoot = false 
	$Timer.start()
	$CollisionShape2D.call_deferred("set_disabled", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if direction == 1:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
	
	if is_dead==false:
		velocity.x = speed*direction
		
		velocity.y += gravity
		
		velocity = move_and_slide(velocity, FLOOR)
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
		$bulletpoint.position.x *= -1
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1
		$bulletpoint.position.x *= -1
	
	if canShoot && fire:
		shoot()


func shoot():
	var target_dir = (Vector2(1,0).rotated(self.global_rotation)*sign($RayCast2D.position.x))
	var bullet_instance = bullet.instance()
	#set the bullet direction using the bulletpoint location
	bullet_instance.start(target_dir, damage, bulletSprite)
	bullet_instance.position = $bulletpoint.global_position
	get_parent().add_child(bullet_instance)
	$FireRate.start()
	fire = false


func _on_Timer_timeout():
	queue_free()

func _on_DetectPlayer_body_entered(body):
	if body.name == "Character":
		target = body
		canShoot = true


func _on_DetectPlayer_body_exited(body):
	if body.name == "Character":
		target = null
		canShoot = false 


func _on_FireRate_timeout():
	fire = true
