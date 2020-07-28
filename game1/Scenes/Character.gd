extends KinematicBody2D


var gravity = 7
const jump = -170
const acceleration = 10
const stop = 10
const FLOOR = Vector2.UP
var hp
var shield
var velocity = Vector2();
var on_ground = false 
var doubleJump = false
var init_pos
var freeHand = true 
var freeHand2 = true 
var moving = false
var animationDirRight = true
var object = null
var can_fire = true 
var onLadder = false
var alive
var direction = 1
var gun
var gunHeld = 1
onready var animationPlayer = $AnimationPlayer
export var speed = 100  # How fast the player will move (pixels/sec).
export var fire_rate = 0.2
export (int) var knockback
export (int) var maxHP
export (int) var maxShield
export (int) var passiveCharge
export (int, 0, 200) var inertia


func _ready():
	init_pos = get_global_transform().origin
	hp = maxHP
	shield = 0
	alive = true
	$UI/HealthBar.getMaxHP(200)
	$statusText/DisplayHP.assign(hp, maxHP)
	$statusText/DisplayShield.assign(shield, maxShield)
	Global.respawnLoc = get_global_transform().origin
	Global.initialMobCount = get_parent().get_node("Mobs").get_child_count()
	Global.mobCount = Global.initialMobCount
	$UI/GunSprite.visible = false

func _physics_process(_delta):
	if alive:
		mousePlace()
		movement()
	
	#move character
	var snap = Vector2.DOWN*6 if on_ground else Vector2.ZERO
	var stopOnSlope = true if get_floor_velocity().x == 0 else false
	velocity.y = move_and_slide_with_snap(velocity, snap, FLOOR, stopOnSlope, 4 , PI/4, false).y
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * inertia)
	
	
	#dropdown make work
	set_collision_mask_bit(5, true)


func _process(delta):
	$statusText/DisplayCoin.setCoin()
	if alive:
		#pickup()
		if !freeHand && object != null:
			$statusText/AmmoBar.getMaxAmmo(object.clipAmmo, object.ammo)
			$UI/ReloadTimer.setReload(object.reloadTime-object.getReloadDuration())
		if Global.hasKey:
			$UI/KeySprite.visible = true
		else:
			$UI/KeySprite.visible = false

func mousePlace():
	if get_viewport().get_mouse_position().x > (get_viewport_rect().size.x/2):
		animationDirRight = true
	else: 
		animationDirRight = false

func _input(event):
	switchWeapon()
	if Input.is_action_just_pressed("revive") && !alive:
		SceneTransition.fadeIn()
		yield(get_tree().create_timer(.5), "timeout")
		set_global_position(Global.respawnLoc)
		SceneTransition.fadeOut()
		
		yield(get_tree().create_timer(.01), "timeout")
		hp = maxHP*0.5
		$UI/HealthBar.setHP(hp)
		$statusText/DisplayHP.getValue(hp)
		$statusText/DisplayText.stop()
		$statusText/DeadMessage.visible_characters = 0
		set_collision_layer_bit(0, true)
		set_collision_layer_bit(1, false)
		alive = true

func switchWeapon():
	if Input.is_action_just_pressed("switchWeapon") && Global.gunID != null && Global.gunID2 != null:
		print(gunHeld)
		if gunHeld == 1:
			gunHeld = 2
			$UI/GunSprite.region_rect.position.x = Global.gunID2.getSprite()
		elif gunHeld == 2:
			gunHeld = 1
			$UI/GunSprite.region_rect.position.x = object.getSprite()
		#make guns invisible if not main gun 
		#make sure they cant be visible and not able to shoot


func movement():
	if Input.is_action_pressed("move_right") && abs(velocity.x) < speed:
		moving = true
		velocity.x += acceleration
		direction = 1
	elif Input.is_action_pressed("move_left")&& abs(velocity.x) < speed:
		moving = true
		velocity.x += -acceleration
		direction = -1
	else:
		if velocity.x > 0:
			velocity.x += -stop
		elif velocity.x < 0:
			velocity.x += stop
	
	
	if abs(velocity.x) < 10:
		velocity.x = 0
		moving = false
	
	
	if Input.is_action_pressed("move_down"):
		set_collision_mask_bit(5, false)
	
	velocity.y += gravity
	
	if is_on_floor():
		on_ground = true
		doubleJump = true
	else: 
		on_ground = false
	
	if Input.is_action_just_pressed("jump") && on_ground:
		velocity.y = jump
		on_ground = false
	#elif Input.is_action_just_pressed("jump") && doubleJump:
	#	velocity.y = jump
		#doubleJump = false
	
	#use a Ladder
	if onLadder:
		on_ground = false
		gravity= 0
		self.z_index = 2
		if Input.is_action_pressed("up"):
			velocity.y = -speed
		elif Input.is_action_pressed("down"):
			velocity.y = speed
		else:
			velocity.y = 0
	else:
		gravity= 7
		self.z_index = 0
	
	
	if !$audio.is_playing() && moving && on_ground:
		$audio.play()
	
	if !moving || !on_ground:
		$audio.stop()
	
	if onLadder:
		animationPlayer.play("Climb")
		if velocity.y == 0:
			animationPlayer.stop(true)
	elif animationDirRight && !on_ground && direction == 1:
		animationPlayer.play("JumpRightLookRight")
	elif !animationDirRight && !on_ground && direction == -1:
		animationPlayer.play("JumpLeftLookLeft")
	elif animationDirRight && !on_ground && direction == -1:
		animationPlayer.play("JumpLeftLookRight")
	elif !animationDirRight && !on_ground && direction == 1:
		animationPlayer.play("JumpRightLookLeft")
	elif animationDirRight && !moving:
		animationPlayer.play("IdleRight")
	elif !animationDirRight && !moving:
		animationPlayer.play("IdleLeft")
	elif animationDirRight && moving && direction == 1:
		animationPlayer.play("RunRightLookRight")
	elif animationDirRight && moving && direction == -1:
		animationPlayer.play("RunLeftLookRight")
	elif !animationDirRight && moving && direction == -1:
		animationPlayer.play("RunLeftLookLeft")
	elif !animationDirRight && moving && direction == 1:
		animationPlayer.play("RunRightLookLeft")

func die():
	alive = false 
	hp = 0
	shield = 0
	velocity.x = 0
	velocity.y = 0
	$UI/HealthBar.setHP(hp)
	$UI/ShieldBar.setShield(shield)
	$statusText/DisplayHP.getValue(hp)
	$statusText/DisplayShield.getValue(shield)
	if animationDirRight && direction == 1:
		animationPlayer.play("DeadRightLookRight")
	elif animationDirRight && direction == -1:
		animationPlayer.play("DeadLeftLookRight")
	elif !animationDirRight && direction == -1:
		animationPlayer.play("DeadLeftLookLeft")
	elif !animationDirRight && direction == 1:
		animationPlayer.play("DeadRightLookLeft")
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, true)
	$statusText/DisplayText.start()
	if (Global.money - 5) >= 0:
		Global.money -= 5
	else:
		Global.money = 0


func handFree():
	freeHand = true
	$statusText/AmmoBar.getMaxAmmo(0, 0)
	$UI/ReloadTimer.setReload(0)
	$UI/GunSprite.visible = false


func hit(damage, hitBy, knock, type):
	if shield > 0 && shield >= damage:
		shield -= damage
		$ShieldCharge.start()
	elif shield > 0 && shield <= damage:
		hp -= (damage-shield)
		shield = 0
	else:
		hp -= damage
		
	if shield == 0:
		$ShieldCharge.stop()
	
	if knock:
		if type == 0:
			velocity = knockback * hitBy.velocity.normalized()
		elif type == 1:
			velocity = knockback * (position - hitBy.position).normalized()
	
	if hp <= 0:
		die()
	$UI/HealthBar.setHP(hp)
	$UI/ShieldBar.setShield(shield)
	$statusText/DisplayHP.getValue(hp)
	$statusText/DisplayShield.getValue(shield)
	
	
func heal(value):
	if hp+value < maxHP:
		hp += value
	else:
		hp = maxHP
	$UI/HealthBar.setHP(hp)
	$statusText/DisplayHP.getValue(hp)

func shield(value):
	if shield+value < maxShield:
		shield += value
	else:
		shield = maxShield
	$UI/ShieldBar.setShield(shield)
	$statusText/DisplayShield.getValue(shield)


func pickup():
	if object != null && Input.is_action_just_pressed("use") && freeHand:
		object.held(self)
		freeHand = false
		$statusText/AmmoBar.getMaxAmmo(object.clipAmmo, object.ammo)
		$UI/ReloadTimer.getMaxReloadTime(object.reloadTime)


func _on_Area2D_body_entered(body):
	#fix the pickup method
	if body.has_method("held") && freeHand:
		object = body
		Global.gunID = object
		object.held(self)
		freeHand = false
		$statusText/AmmoBar.getMaxAmmo(object.clipAmmo, object.ammo)
		$UI/ReloadTimer.getMaxReloadTime(object.reloadTime)
		$UI/GunSprite.visible = true
		$UI/GunSprite.region_rect.position.x = object.getSprite()
	elif body.has_method("held") && Global.gunID != null && Global.gunID2 == null:
		Global.gunID2 = body
		print(Global.gunID2)
		print(Global.gunID)
	
	if body.has_method("magnet"):
		body.queue_free()
		Global.money += 1
	if body.has_method("hasAmmo") && object != null:
		object.clipAmmo += object.ammoPerClip
		body.queue_free()

#Object suddenly becomes null
func _on_Area2D_body_exited(body):
	if body.has_method("held") && freeHand:
		object = null
		Global.gunID = null


func _on_ShieldCharge_timeout():
	if shield + passiveCharge < maxShield:
		shield += passiveCharge
	else:
		shield = maxShield
		$ShieldCharge.stop()
	$UI/ShieldBar.setShield(shield)
	$statusText/DisplayShield.getValue(shield)


func _on_DisplayText_timeout():
	$statusText/DeadMessage.visible_characters += 1


func _on_Magnet_body_entered(body):
	if body.has_method("magnet"):
		body.magnet(self)
