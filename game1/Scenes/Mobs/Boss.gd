extends "res://Scenes/Mobs/mobs.gd"

var target = null
var bulletSprite
var canShoot = false
var fire = true
var target_dir
var current_dir
var shootLeft
var disabled
var pause
var hitPos
var chaseDirection
var bulletInstances
var initAltitude
var direction = 1
var is_dead = false
export (float) var fireRates
export (float) var turretTurn
export (float) var wait
export (int) var bulletSpeed

var rocket = preload("res://Scenes/Weapons/rocket.tscn")
var key = preload("res://Scenes/Items/keyCard.tscn")

func _ready():
	bulletSprite = 0
	shootLeft = true
	$WaitTime.set_wait_time(wait)
	$FireRate.set_wait_time(fireRates)
	$CanvasLayer/HealthBar.getMaxHP(hp)
	disabled = false
	pause = false
	bulletInstances = 0
	initPos = position.x
	initAltitude = round(position.y)

func hit(damage, pos, knock, type):
	hp -= damage
	$CanvasLayer/HealthBar.setHP(hp)
	if hp <=0:
		dead()

func dead():
	canShoot = false 
	disabled = true
	is_dead = true
	$Timer.start()
	$Fire.visible = true
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Tween.interpolate_property($Sprite, "modulate", Color(1,1,1,1), Color(1,1,1,0), $Timer.wait_time, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Fire, "modulate", Color(1,1,1,1), Color(1,1,1,0), $Timer.wait_time, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Turret, "modulate", Color(1,1,1,1), Color(1,1,1,0), $Timer.wait_time, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()

func _on_DetectPlayer_body_entered(body):
	if body.name == "Character":
		target = body
		canShoot = true
		bulletInstances = 0


func _on_DetectPlayer_body_exited(body):
	if body.name == "Character":
		canShoot = false
		target = null


func _on_FireRate_timeout():
	fire = true
	if shootLeft:
		shootLeft = false
	else:
		shootLeft = true
	


func _on_Timer_timeout():
	var key_instance = key.instance()
	key_instance.position = self.global_position
	yield(get_tree(), "idle_frame")
	get_parent().add_child(key_instance)
	queue_free()


func _on_WaitTime_timeout():
	pause = false
	bulletInstances = 0

func patrol():
	if int(position.x-initPos) > patrolRange && !detected:
		direction = -abs(direction)
	elif int(position.x-initPos) < -patrolRange && !detected:
		direction = abs(direction)

func chase():
	chaseDirection =  target.position - position
	velocity = chaseDirection.normalized() * speed

func detect():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, target.position, [self], collision_mask)
	if result:
		hitPos = result.position
		#update()
		if result.collider.name == "Character":
			chase()
			detected = true
		else:
			detected = false


func _physics_process(delta):
	if !is_dead:
		if target:
			detect()
		else:
			patrol()
			if initAltitude > round(position.y):
				velocity.y += 1
			elif initAltitude < round(position.y):
				velocity.y -= 1
			else:
				velocity.y = 0
			detected = false
		velocity.x = speed*direction
		velocity = move_and_slide(velocity, FLOOR, true, 4 , PI/4, false)
		
		if is_on_wall():
				direction = direction * -1

func _process(delta):
	#shooting direction
	if canShoot && !disabled:
		target_dir = (target.global_position-global_position).normalized()
		current_dir = Vector2(1,0).rotated($Turret.global_rotation)
		$Turret.global_rotation = current_dir.linear_interpolate(target_dir, delta * turretTurn).angle()
		
		if fire && target_dir.dot(current_dir) > 0.9 && !pause:
			var bullet_instance = bullet.instance()
			var rocket_instance = rocket.instance()
			#set the bullet direction using the bulletpoint location
			rocket_instance.start(current_dir, damage, bulletSprite, bulletSpeed, false, false, true)
			bullet_instance.start(current_dir, damage*2, bulletSprite, bulletSpeed, false, false, true)
			if shootLeft:
				bullet_instance.position = $Turret/bulletpoint1.global_position
			else:
				bullet_instance.position = $Turret/bulletpoint2.global_position
			rocket_instance.position = $Turret/rocketpoint1.global_position
			if bulletInstances % 2 == 0:
				get_parent().add_child(rocket_instance)
			get_parent().add_child(bullet_instance)
			
			bulletInstances += 1
			if bulletInstances == 6:
				$WaitTime.start()
				pause = true
			$FireRate.start()
			fire = false
