extends "res://Scenes/Mobs/mobs.gd"


var direction = 1
var is_dead = false 
var moving
var target
var hitPos
var initialSpeed
var attacking
export (int) var fastSpeed 

var dieAudio = preload("res://Resources/Audio/Mobs/Robots/MachinePowerOff.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthBar.getMaxHP(hp)
	moving = true
	initPos = position.x
	initialSpeed = speed
	attacking = false


func hit(damage, pos, knock, type):
	hp -= damage
	$HealthBar.setHP(hp)
	$audio.play()
	if hp <=0:
		dead()


func dead():
	for i in range(0, coinsDropped):
		coin_instance = coin.instance()
		get_parent().get_parent().get_parent().call_deferred("add_child", coin_instance)
		coin_instance.position = position
	dropAmmo(1)
	is_dead = true
	velocity = Vector2(0,0)
	$Timer.start()
	if direction == 1:
		$AnimationPlayer.play("DeathRight")
	else:
		$AnimationPlayer.play("DeathLeft")
	
	$audio.set_stream(dieAudio)
	$audio.play()
	$fire.visible = true
	$CollisionShape2D.call_deferred("set_disabled", true)
	$DetectBox/CollisionShape2D.call_deferred("set_disabled", true)
	$AnimationDuration.stop()
	$Tween.interpolate_property($Body, "modulate", Color(1,1,1,1), Color(1,1,1,0), $Timer.wait_time, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Arm, "modulate", Color(1,1,1,1), Color(1,1,1,0), $Timer.wait_time, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($HealthBar, "modulate", Color(1,1,1,1), Color(1,1,1,0), $Timer.wait_time, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($fire, "modulate", Color(1,1,1,1), Color(1,1,1,0), $Timer.wait_time, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if !is_dead && moving:
		patrol()
		if target:
			detect()
		else:
			detected = false
		
		
		if direction == 1:
			$RayCast2D.position.x = abs($RayCast2D.position.x)
			$AnimationPlayer.play("RunRight")
		else:
			$AnimationPlayer.play("RunLeft")
			$RayCast2D.position.x = -abs($RayCast2D.position.x)
		
		
		velocity.x = speed*direction
		velocity.y += gravity
		velocity = move_and_slide(velocity, FLOOR, true, 4 , PI/4, false)
		
		
		for index in get_slide_count():
			var collision = get_slide_collision(index)
			if collision.collider.is_in_group("bodies"):
				collision.collider.apply_central_impulse(-collision.normal * inertia)
	
	if !is_dead && attacking && target != null:
		attack()
	
	
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
	
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1

func detect():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, target.position, [self], collision_mask)
	if result:
		hitPos = result.position
		#update()
		if result.collider.name == "Character":
			chase()
			detected = true
			speed = fastSpeed
			$AnimationPlayer.playback_speed = 2
		else:
			detected = false
			speed = initialSpeed
			$AnimationPlayer.playback_speed = 1


func chase():
	if target.position.x > position.x:
		direction = 1
		$RayCast2D.position.x = abs($RayCast2D.position.x)
	elif target.position.x < position.x:
		direction = -1
		$RayCast2D.position.x = -abs($RayCast2D.position.x)

func _draw():
	if target:
		draw_line(Vector2(), (hitPos-position).rotated(-rotation), Color(1,.3,.3))

func patrol():
	if int(position.x-initPos) > patrolRange && !detected:
		direction = -abs(direction)
	elif int(position.x-initPos) < -patrolRange && !detected:
		direction = abs(direction)


func attack():
	if target.global_position.x < global_position.x:
		$AnimationPlayer.play("HitLeft")
	else:
		$AnimationPlayer.play("HitRight")
	
	$AnimationDuration.start()


func _on_Timer_timeout():
	get_parent().remove_child(self)
	Global.mobCount -= 1
	queue_free()


func _on_HurtBox_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage, self, true, 2)

func _on_AnimationDuration_timeout():
	moving = true


func _on_DetectBox_body_entered(body):
	moving = false
	attacking = true

func _on_DetectBox_body_exited(body):
	attacking = false

func _on_DetectPlayer_body_entered(body):
	if body.name == "Character":
		detected = true
		target = body
		if body.global_position.x > global_position.x:
			direction = 1
			$RayCast2D.position.x = abs($RayCast2D.position.x)
		else:
			direction = -1
			$RayCast2D.position.x = -abs($RayCast2D.position.x)


func _on_DetectPlayer_body_exited(body):
	if body.name == "Character":
		detected = false
		target = null



