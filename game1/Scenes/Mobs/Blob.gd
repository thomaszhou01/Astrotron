extends "res://Scenes/Mobs/mobs.gd"



var direction = 1
var is_dead = false
var target = null
var stop
var paused
var hitPos
var object

var dieAudio = preload("res://Resources/Audio/Mobs/Slime/slimeDie.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthBar.getMaxHP(hp)
	stop = false
	paused = false
	initPos = position.x
	

func hit(damage, pos, knock, type):
	hp -= damage
	$HealthBar.setHP(hp)
	$audio.play()
	if hp <=0:
		dead()


func dead():
	#add coins
	for i in range(0, coinsDropped):
		coin_instance = coin.instance()
		get_parent().get_parent().get_parent().call_deferred("add_child", coin_instance)
		coin_instance.position = position
	dropAmmo(4)
	is_dead = true
	velocity = Vector2(0,0)
	$audio.set_stream(dieAudio)
	$audio.play()
	$Particles2D.visible = true
	$Particles2D.emitting = true
	$AnimatedSprite.play("dead")
	$Timer.start()
	$CollisionShape2D.call_deferred("set_disabled", true)
	$BodyDetector/CollisionShape2D.call_deferred("set_disabled", true)
	$Tween.interpolate_property($AnimatedSprite, "modulate", Color(1,1,1,1), Color(1,1,1,0), $Timer.wait_time, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($HealthBar, "modulate", Color(1,1,1,1), Color(1,1,1,0), $Timer.wait_time, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()

#make blob stop if going off edge
func _physics_process(_delta):
	if !is_dead && !paused:
		if direction == 1:
			$RayCast2D.position.x = abs($RayCast2D.position.x)
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
			$RayCast2D.position.x = -abs($RayCast2D.position.x)
		
		if target:
			detect()
		else:
			detected = false
		patrol()
		if $RayCast2D.is_colliding() == false && detected:
			stop = true
		else:
			stop = false
	
		if !stop:
			$AnimatedSprite.play("walk")
			velocity.x = speed*direction
			
			if !is_on_floor():
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

func _draw():
	if target:
		draw_line(Vector2(), (hitPos-position).rotated(-rotation), Color(1,.3,.3))

func _on_Timer_timeout():
	get_parent().remove_child(self)
	Global.mobCount -= 1
	queue_free()

#implement hit if stuck on body 
func _on_BodyDetector_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage, self, true, 1)
		object = body
		$DamageTick.start()


func _on_BodyDetector_body_exited(body):
	$DamageTick.stop()

func _on_Pause_timeout():
	paused = false


func _on_DetectPlayer_body_entered(body):
	if body.name == "Character":
		target = body


func _on_DetectPlayer_body_exited(body):
	if body.name == "Character":
		target = null




func _on_DamageTick_timeout():
	object.hit(damage, self, true, 0)
