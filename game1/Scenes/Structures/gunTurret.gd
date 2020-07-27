extends StaticBody2D

var target = null
var bulletSprite
var canShoot = false
var fire = true
var target_dir
var current_dir
var shootLeft
var disabled
var hp
var pause
var bulletInstances
export (int) var maxHP
export (float) var fireRates
export (float) var turretTurn
export (float) var wait
export (int) var damage
export (int) var bulletSpeed
export (int) var detectRadius 
var bullet = preload("res://Scenes/bullet.tscn")

func _ready():
	bulletSprite = 0
	shootLeft = true
	$WaitTime.set_wait_time(wait)
	$FireRate.set_wait_time(fireRates)
	$HealthBar.getMaxHP(maxHP)
	hp = maxHP
	disabled = false
	pause = false
	bulletInstances = 0
	$DetectPlayer/CollisionShape2D.shape.radius = detectRadius

func hit(dmg, pos, knock):
	hp -= dmg
	$HealthBar.setHP(hp)
	if hp <=0:
		dead()

func dead():
	canShoot = false 
	disabled = true
	$Timer.start()
	$CollisionShape2D.call_deferred("set_disabled", true)
	$HealthBar.revive($Timer.wait_time)


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
	if target != null:
		canShoot = true
	else:
		canShoot = false
	disabled = false
	hp = maxHP
	$HealthBar.setHP(hp)
	$CollisionShape2D.call_deferred("set_disabled", false)


func _on_WaitTime_timeout():
	pause = false
	bulletInstances = 0


func _process(delta):
	#shooting direction
	if canShoot && !disabled:
		target_dir = (target.global_position-global_position).normalized()
		current_dir = Vector2(1,0).rotated($Turret.global_rotation)
		$Turret.global_rotation = current_dir.linear_interpolate(target_dir, delta * turretTurn).angle()
		
		if fire && target_dir.dot(current_dir) > 0.9 && !pause:
			var bullet_instance = bullet.instance()
			#set the bullet direction using the bulletpoint location
			bullet_instance.start(current_dir, damage, bulletSprite, bulletSpeed, false, false, true)
			if shootLeft:
				bullet_instance.position = $Turret/bulletpoint1.global_position
			else:
				bullet_instance.position = $Turret/bulletpoint2.global_position
			get_parent().add_child(bullet_instance)
			bulletInstances += 1
			if bulletInstances == 4:
				$WaitTime.start()
				pause = true
			$FireRate.start()
			fire = false
