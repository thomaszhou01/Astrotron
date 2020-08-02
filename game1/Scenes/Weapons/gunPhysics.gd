extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bullet = preload("res://Scenes/bullet.tscn")
var grenade = preload("res://Scenes/Weapons/grenade.tscn")
var rocket = preload("res://Scenes/Weapons/rocket.tscn")
var held = false
var canShoot = true
var ammo
var reloading
var parent
var clipAmmo
var used
var originallyInScene = true
export (int) var damage 
export (int) var bulletSprite
export (float) var fireRate
export (int) var bulletSpeed
export (int) var bulletType
export (int) var ammoPerClip
export (int) var reloadTime

var reload = preload("res://Resources/Audio/Items/Guns/reload.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.set_wait_time(fireRate)
	$Reload.set_wait_time(reloadTime)
	if originallyInScene:
		ammo = ammoPerClip
		clipAmmo = ammoPerClip * 3
	reloading = false
	used = false


func _process(delta):
	if held && parent.alive:
		set_linear_velocity(Vector2(0,0))
		set_angular_velocity(0)
		self.look_at(get_global_mouse_position())
		self.position = parent.get_node("holdPoint").global_position
		if self.global_rotation<1.5 && self.global_rotation>-1.5:
			$Sprite.flip_v = false
			$bulletpoint.position.y = -abs($bulletpoint.position.y)
		else:
			$Sprite.flip_v = true 
			$bulletpoint.position.y = abs($bulletpoint.position.y)
	elif held && !parent.alive:
		self.position = parent.get_node("holdPoint").global_position
	
	if held && parent.alive && used:
		#Reload
		if (Input.is_action_just_pressed("reload") || (Input.is_action_pressed("fire") && ammo == 0)) && held && ammo != ammoPerClip && $Reload.get_time_left() == 0 && clipAmmo != 0:
			reloading = true
			$Reload.start()
			$effects.set_stream(reload)
			$effects.play()
		
		if reloading || ammo == 0:
			pass
		elif (Input.is_action_pressed("fire") && held) && canShoot && bulletType == 0:
			var bullet_instance = bullet.instance()
			var direction = Vector2(1,0).rotated(self.global_rotation)
			#set the bullet direction using the bulletpoint location
			bullet_instance.start(direction, damage, bulletSprite, bulletSpeed, false, true, false)
			get_parent().add_child(bullet_instance)
			bullet_instance.position = $bulletpoint.global_position
			canShoot = false
			ammo -= 1
			$Timer.start()
			$audio.play()
		elif (Input.is_action_pressed("fire") && held) && canShoot && bulletType == 1:
			var grenade_instance = grenade.instance()
			var direction = Vector2(1,0).rotated(self.global_rotation)
			#set the bullet direction using the bulletpoint location
			grenade_instance.start(direction, damage, bulletSprite, bulletSpeed, true)
			grenade_instance.shoot()
			get_parent().add_child(grenade_instance)
			grenade_instance.position = $bulletpoint.global_position
			canShoot = false
			ammo -= 1
			$Timer.start()
			$audio.play()
		elif (Input.is_action_pressed("fire") && held) && canShoot && bulletType == 2:
			var rocket_instance = rocket.instance()
			var direction = Vector2(1,0).rotated(self.global_rotation)
			#set the bullet direction using the bulletpoint location
			rocket_instance.start(direction, damage, bulletSprite, bulletSpeed, false, true, false)
			get_parent().add_child(rocket_instance)
			rocket_instance.position = $bulletpoint.global_position
			canShoot = false
			ammo -= 1
			$Timer.start()
			$audio.play()
		
		
	elif held && !parent.alive && reloading:
		$Reload.stop()
		reloading = false


func drop():
	held = false
	self.global_position.y = self.global_position.y - 5
	$Sprite.offset.x = 0
	$Reload.stop()
	reloading = false
	$hitBox.disabled = false
	$Sprite.visible = true
	used = false

func getReloadDuration():
	return $Reload.get_time_left()

func getSprite():
	return ($Sprite.region_rect.position.x)

func notUsed():
	used = false
	$Sprite.visible = false
	$Reload.stop()
	reloading = false

func used():
	used = true
	$Sprite.visible = true
