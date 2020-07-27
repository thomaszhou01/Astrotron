extends "res://Scenes/Weapons/gunPhysics.gd"


func held(parentName):
	parent = parentName
	held = true
	$Sprite.offset.x = 5
	$hitBox.call_deferred("disabled", true)


func _on_Timer_timeout():
	canShoot = true


func _on_Reload_timeout():
	reloading = false
	if (clipAmmo + ammo) >= ammoPerClip:
		clipAmmo -= ammoPerClip - ammo
		ammo = ammoPerClip
	elif (clipAmmo + ammo) < ammoPerClip:
		ammo = clipAmmo + ammo
		clipAmmo = 0
