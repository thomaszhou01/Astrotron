extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bullet = preload("res://Scenes/bullet.tscn")
var held = false
var canShoot = true
export (int) var damage 
export (int) var bulletSprite
export (float) var fireRate
export (int) var bulletSpeed 

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.set_hframes(3)
	$Timer.set_wait_time(fireRate)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if held:
		self.look_at(get_global_mouse_position())
		self.position = get_node("../Character/holdPoint").global_position
		if self.global_rotation<1.5 && self.global_rotation>-1.5:
			$Sprite.flip_v = false
			$bulletpoint.position.y = -0.5
		else:
			$Sprite.flip_v = true 
			$bulletpoint.position.y = 0.5
	
	if (Input.is_action_pressed("fire") && held) && canShoot:
		var bullet_instance = bullet.instance()
		var direction = Vector2(1,0).rotated(self.global_rotation)
		#set the bullet direction using the bulletpoint location
		bullet_instance.start(direction, damage, bulletSprite, bulletSpeed)
		get_parent().add_child(bullet_instance)
		bullet_instance.position = $bulletpoint.global_position
		canShoot = false
		$Timer.start()
	elif Input.is_action_just_pressed("drop") && held:
		held = false
		get_parent().get_node("Character").handFree()
		self.global_position.y = self.global_position.y - 5
		$Sprite.offset.x = 0
