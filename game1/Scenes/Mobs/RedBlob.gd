extends "res://Scenes/Mobs/mobs.gd"


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
var hitPos
export (float) var turretTurn
export (float) var fireRate 
export (int) var bulletSpeed 



func _ready():
	bulletSprite = 2
	right = true
	$FireRate.set_wait_time(fireRate)
	$AnimatedSprite.play("default")
	$HealthBar.getMaxHP(hp)
	initPos = position.x


func hit(dmg, pos, knock, type):
	hp -= dmg
	$HealthBar.setHP(hp)
	if hp <=0:
		dead()

func dead():
	for _i in range(0, coinsDropped):
		coin_instance = coin.instance()
		get_parent().get_parent().get_parent().call_deferred("add_child", coin_instance)
		coin_instance.position = position
	dropAmmo(2)
	is_dead = true
	velocity = Vector2(0,0)
	canShoot = false 
	stop = false 
	turretTurn = 10
	$Timer.start()
	$FireRate.stop()
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Tween.interpolate_property($AnimatedSprite, "modulate", Color(1,1,1,1), Color(1,1,1,0), $Timer.wait_time, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#shooting
	#update()
	if canShoot:
		target_dir = (target.global_position-global_position).normalized()
		current_dir = Vector2(1,0).rotated($Turret.global_rotation)
		$Turret.global_rotation = current_dir.linear_interpolate(target_dir, delta * turretTurn).angle()
		aim()
	
	if direction == 1 || right:
		$AnimatedSprite.flip_h = false
		
	elif direction == -1 || !right:
		$AnimatedSprite.flip_h = true
	
	if !is_dead:
		patrol()
		
		velocity.x = speed*direction
		
		velocity.y += gravity
		
		velocity = move_and_slide(velocity, FLOOR, true, 4 , PI/4, false)
		for index in get_slide_count():
			var collision = get_slide_collision(index)
			if collision.collider.is_in_group("bodies"):
				collision.collider.apply_central_impulse(-collision.normal * inertia)
	
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
	
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1

func aim():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, target.position, [self], collision_mask)
	if result:
		hitPos = result.position
		if result.collider.name == "Character":
			chase()
			detected = true
			if fire && target_dir.dot(current_dir) > 0.9:
				shoot()
		else:
			detected = false

func _draw():
	if target:
		draw_circle(Vector2(), $DetectPlayer/CollisionShape2D.shape.radius, Color(.3,.5,.5, 0.2))
		draw_line(Vector2(), (hitPos-position).rotated(-rotation), Color(1,.3,.3))


func shoot():
	var bullet_instance = bullet.instance()
	#set the bullet direction using the bulletpoint location
	bullet_instance.start(current_dir, damage, bulletSprite, bulletSpeed, true, false, true)
	bullet_instance.position = $Turret/bulletpoint.global_position
	get_parent().add_child(bullet_instance)
	$FireRate.start()
	fire = false
	if target_dir.x >= 0:
		right = true
	else:
		right = false


func patrol():
	if int(position.x-initPos) > patrolRange && !detected:
		direction = -abs(direction)
	elif int(position.x-initPos) < -patrolRange && !detected:
		direction = abs(direction)

func chase():
	if target.position.x > position.x:
		direction = 1
		$RayCast2D.position.x = abs($RayCast2D.position.x)
	elif target.position.x < position.x:
		direction = -1
		$RayCast2D.position.x = -abs($RayCast2D.position.x)

func _on_Timer_timeout():
	get_parent().remove_child(self)
	Global.mobCount -= 1
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
