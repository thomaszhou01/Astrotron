extends "res://Scenes/Mobs/mobs.gd"


var direction = 1
var is_dead = false
var target = null
var hitPos
var object
var initialSpeed
var chaseDirection
var initAltitude
var hitEnemy
export (int) var fastSpeed 
var dieAudio = preload("res://Resources/Audio/Mobs/Slime/slimeDie.wav")

#currently redblob bullets kill mob 
func _ready():
	$HealthBar.getMaxHP(hp)
	initPos = position.x
	initAltitude = position.y + 1
	initialSpeed = speed
	hitEnemy = false

func hit(damage, pos, knock, type):
	hp -= damage
	$HealthBar.setHP(hp)
	$audio.play()
	if hp <=0:
		dead()


func dead():
	#add coins
	hitEnemy = true
	for i in range(0, coinsDropped):
		coin_instance = coin.instance()
		get_parent().get_parent().get_parent().call_deferred("add_child", coin_instance)
		coin_instance.position = position
	dropAmmo(7)
	is_dead = true
	velocity = Vector2(0,0)
	$audio.set_stream(dieAudio)
	$audio.play()
	$DeadParticles.visible = true
	$DeadParticles.emitting = true
	$Timer.start()
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Tween.interpolate_property($AnimatedSprite, "modulate", Color(1,1,1,1), Color(1,1,1,0), $Timer.wait_time, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($HealthBar, "modulate", Color(1,1,1,1), Color(1,1,1,0), $Timer.wait_time, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Particles2D, "modulate", Color(1,1,1,1), Color(1,1,1,0), $Timer.wait_time, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()

#make blob stop if going off edge
func _physics_process(_delta):
	if !is_dead:
		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
		
		if target:
			detect()
		else:
			if initAltitude > position.y:
				velocity.y += 1
			elif initAltitude < position.y:
				velocity.y -= 1
			else:
				velocity.y = 0
			velocity.x = speed*direction
			detected = false
		
		patrol()
		$AnimatedSprite.play("default")
		
		
		velocity = move_and_slide(velocity, FLOOR, true, 4 , PI/4, false)
			
		for index in get_slide_count():
			var collision = get_slide_collision(index)
			if collision.collider.is_in_group("bodies"):
				collision.collider.apply_central_impulse(-collision.normal * inertia)
		
		if is_on_wall():
			direction = direction * -1


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
		else:
			detected = false
			speed = initialSpeed


func patrol():
	if int(position.x-initPos) > patrolRange && !detected:
		direction = -abs(direction)
	elif int(position.x-initPos) < -patrolRange && !detected:
		direction = abs(direction)

func chase():
	chaseDirection =  target.position - position
	velocity = chaseDirection.normalized() * speed

func _draw():
	if target:
		draw_line(Vector2(), (hitPos-position).rotated(-rotation), Color(1,.3,.3))

func _on_Timer_timeout():
	get_parent().remove_child(self)
	Global.mobCount -= 1
	queue_free()
	print("k")



func _on_DetectPlayer_body_entered(body):
	if body.name == "Character":
		target = body


func _on_DetectPlayer_body_exited(body):
	if body.name == "Character":
		target = null


func _on_Area2D_body_entered(body):
	if !hitEnemy && body.name == "Character":
		body.hit(damage, self, true, 2)
		dead()
