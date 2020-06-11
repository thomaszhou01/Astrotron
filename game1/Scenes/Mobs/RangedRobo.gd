extends KinematicBody2D

const gravity = 50
const speed = 60
const FLOOR = Vector2(0, -1)
var bullet = preload("res://Scenes/bullet.tscn")
var velocity = Vector2();
var direction = 1
var target = null
var bulletSprite
var canShoot = false
var fire = true
var is_dead = false 
var stop
var right
var target_dir
var current_dir
export (float) var turretTurn
export (float) var fireRate 
export (int) var hp
export (int) var damage
export (int) var bulletSpeed 


# Called when the node enters the scene tree for the first time.

func _ready():
	bulletSprite = 0
	right = true
	$FireRate.set_wait_time(fireRate)

# warning-ignore:shadowed_variable
func hit(dmg):
	hp -= dmg
	if hp <=0:
		dead()

func dead(): 
	is_dead = true
	velocity = Vector2(0,0)
	canShoot = false 
	stop = false 
	turretTurn = 10
	$Timer.start()
	$CollisionShape2D.call_deferred("set_disabled", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	#shooting
	if canShoot:
		target_dir = (target.global_position-global_position).normalized()
		current_dir = Vector2(1,0).rotated($Turret.global_rotation)
		$Turret.global_rotation = current_dir.linear_interpolate(target_dir, delta * turretTurn).angle()
		if fire && target_dir.dot(current_dir) > 0.9:
			var bullet_instance = bullet.instance()
			#set the bullet direction using the bulletpoint location
			bullet_instance.start(current_dir, damage, bulletSprite, bulletSpeed)
			bullet_instance.position = $Turret/bulletpoint.global_position
			get_parent().add_child(bullet_instance)
			$FireRate.start()
			fire = false
			if target_dir.x >= 0:
				right = true
			else:
				right = false

	
	
	if direction == 1 || right:
		$Sprite.flip_h = false
		
	elif direction == -1 || !right:
		$Sprite.flip_h = true
	
	if !is_dead:
		velocity.x = speed*direction
		
		velocity.y += gravity
		
		velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
	
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1




func _on_Timer_timeout():
	queue_free()

func _on_DetectPlayer_body_entered(body):
	if body.name == "Character":
		target = body
		canShoot = true
		stop = true


func _on_DetectPlayer_body_exited(body):
	if body.name == "Character":
		target = null
		canShoot = false 
		stop = false


func _on_FireRate_timeout():
	fire = true
