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
var init_pos
var moving = false
var animationDirRight = true
var object = null
var object2 = null
var tempObject = null
var can_fire = true 
var onLadder = false
var damageTaken = 0
var alive
var direction = 1
var gun
var gunHeld = 1
var canDrop = true
var canSetAmmo
onready var animationPlayer = $AnimationPlayer
export var speed = 100  # How fast the player will move (pixels/sec).
export var fire_rate = 0.2
export (int) var knockback
export (int) var maxHP
export (int) var maxShield
export (int) var passiveCharge
export (int, 0, 200) var inertia

var equip = preload("res://Resources/Audio/Player/equip.wav")
var clipPickup = preload("res://Resources/Audio/Player/weapload.wav")
var coinPickup = preload("res://Resources/Audio/Player/ring_inventory.wav")

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
	canSetAmmo = true

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
		if (object != null || object2 != null) && canSetAmmo:
			if gunHeld == 1 && object != null:
				$statusText/AmmoBar.getMaxAmmo(object.clipAmmo, object.ammo)
				$UI/ReloadTimer.setReload(object.reloadTime-object.getReloadDuration())
			elif gunHeld == 2 && object2 != null:
				$statusText/AmmoBar.getMaxAmmo(object2.clipAmmo, object2.ammo)
				$UI/ReloadTimer.setReload(object2.reloadTime-object2.getReloadDuration())
		else:
			$statusText/AmmoBar.getMaxAmmo(0,0)
			$UI/ReloadTimer.setReload(0)
			$UI/GunSprite.visible = false
		
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
	if alive && Input.is_action_just_pressed("use"):
		yield(get_tree(), "idle_frame")
		pickup()
	if Input.is_action_just_pressed("switchWeapon") && object != null && object2 != null && alive:
		yield(get_tree(), "idle_frame")
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
		damageTaken = 0

func switchWeapon():
	if gunHeld == 1:
		object.notUsed()
		object2.used()
		gunHeld = 2
		$UI/GunSprite.region_rect.position.x = object2.getSprite()
		$statusText/AmmoBar.getMaxAmmo(object2.clipAmmo, object2.ammo)
		$UI/ReloadTimer.getMaxReloadTime(object2.reloadTime)
	elif gunHeld == 2:
		object.used()
		object2.notUsed()
		gunHeld = 1
		$statusText/AmmoBar.getMaxAmmo(object.clipAmmo, object.ammo)
		$UI/ReloadTimer.getMaxReloadTime(object.reloadTime)
		$UI/GunSprite.region_rect.position.x = object.getSprite()


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
	else: 
		on_ground = false
	
	if Input.is_action_just_pressed("jump") && on_ground:
		velocity.y = jump
		on_ground = false
	
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
	if object != null && object2 != null:
		if gunHeld == 1:
			object.drop()
			object = null
			Global.gunID = null
		elif gunHeld == 2:
			object2.drop()
			object2 = null
			Global.gunID2 = null


func hit(damage, hitBy, knock, type):
	if alive:
		#determines damage taken to shield or health
		if shield > 0 && shield >= damage:
			shield -= damage
			$ShieldCharge.start()
		elif shield > 0 && shield <= damage:
			hp -= (damage-shield)
			shield = 0
			damageTaken += (damage-shield)
		else:
			hp -= damage
			damageTaken += damage
		
		if $Tween.is_active():
			$Tween.stop($UI/DamagedTint, "modulate")
		$Tween.interpolate_property($UI/DamagedTint, "modulate", Color(1,1,1,(float(damageTaken)/maxHP)), Color(1,1,1,0), 2, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$Tween.start()
		
		#stops charging shield
		if shield == 0:
			$ShieldCharge.stop()
		
		#apply knockback
		if knock:
			if type == 0:
				velocity = knockback * hitBy.velocity.normalized()
			elif type == 1:
				velocity = knockback * (position - hitBy.position).normalized()
		
		#kill
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
	if tempObject != null:
		if object != tempObject && object2 != tempObject:
			if object != null && object2 != null:
				canSetAmmo = false
				handFree()
			
			if object == null && object2 == null && tempObject != null:
				object = tempObject
				Global.gunID = object
				object.held(self)
				object.used()
				$statusText/AmmoBar.getMaxAmmo(object.clipAmmo, object.ammo)
				$UI/ReloadTimer.getMaxReloadTime(object.reloadTime)
				$UI/GunSprite.visible = true
				$UI/GunSprite.region_rect.position.x = object.getSprite()
			elif object != null && object2 == null && tempObject != null:
				object2 = tempObject
				Global.gunID2 = object2
				object2.held(self)
				if canSetAmmo:
					object2.notUsed()
				else:
					object2.used()
					$UI/GunSprite.region_rect.position.x = object2.getSprite()
					$statusText/AmmoBar.getMaxAmmo(object2.clipAmmo, object2.ammo)
					$UI/ReloadTimer.getMaxReloadTime(object2.reloadTime)
			elif object == null && object2 != null && tempObject != null:
				object = tempObject
				Global.gunID = object
				object.held(self)
				if canSetAmmo:
					object.notUsed()
				else:
					object.used()
					$UI/GunSprite.region_rect.position.x = object.getSprite()
					$statusText/AmmoBar.getMaxAmmo(object.clipAmmo, object.ammo)
					$UI/ReloadTimer.getMaxReloadTime(object.reloadTime)
			canSetAmmo = true
			
			if object != null && object.originallyInScene:
				$effects.set_stream(equip)
				$effects.play()
			elif object != null && !object.originallyInScene:
				object.originallyInScene = true
			
			if object2 != null && object2.originallyInScene:
				$effects.set_stream(equip)
				$effects.play()
			elif object2 != null && !object2.originallyInScene:
				object2.originallyInScene = true
		
		tempObject = null


func _on_Area2D_body_entered(body):
	#fix the pickup method
	if body.has_method("held"):
		yield(get_tree(), "idle_frame")
		tempObject = body

	if body.has_method("magnet"):
		body.queue_free()
		Global.money += 1
		$effects.set_stream(coinPickup)
		$effects.play()
	if body.has_method("hasAmmo"):
		if object != null && gunHeld == 1:
			object.clipAmmo += object.ammoPerClip
			body.queue_free()
			$effects.set_stream(clipPickup)
			$effects.play()
		elif object2 != null && gunHeld == 2:
			object2.clipAmmo += object2.ammoPerClip
			body.queue_free()
			$effects.set_stream(clipPickup)
			$effects.play()

#Object suddenly becomes null
func _on_Area2D_body_exited(body):
	if body.has_method("held") && body == tempObject:
		tempObject = null


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


func _on_Tween_tween_completed(object, key):
	if object == $UI/DamagedTint:
		damageTaken = 0
