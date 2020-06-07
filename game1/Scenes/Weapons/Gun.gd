extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bullet = preload("res://Scenes/bullet.tscn")
var held = false
var direction = 1
var damage = 50
var canShoot = true

#collision box not working/sticking to railgun

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if held:
		self.rotation_degrees = 0
		self.position = get_parent().get_node("../Character/holdPoint").global_position
		if get_parent().get_node("../Character/holdPoint").position.x == -4:
			$Sprite.flip_h = true
			$bulletpoint.position.x = -10
		else:
			$Sprite.flip_h = false 
			$bulletpoint.position.x = 10
	
	if (Input.is_action_just_pressed("fire") && held) && canShoot:
		var bullet_instance = bullet.instance()
		
		#set the bullet direction using the bulletpoint location
		bullet_instance.set_bullet_direction(sign($bulletpoint.position.x))
		bullet_instance.set_damage(damage)
		bullet_instance.setSprite(0)
		get_parent().get_parent().add_child(bullet_instance)
		bullet_instance.position = $bulletpoint.global_position
		canShoot = false
		$Timer.start()
	elif Input.is_action_just_pressed("drop") && held:
		get_parent().get_node("Character").handFree()
		held = false
		self.global_position.y = self.global_position.y - 5
		self.global_position.x = self.global_position.x + 10 * sign($bulletpoint.position.x)



func held():
	held = true


func _on_Timer_timeout():
	canShoot = true
