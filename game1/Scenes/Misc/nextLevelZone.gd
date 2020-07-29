extends Area2D


export (Resource) var maps
var gun

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_nextLevelZone_body_entered(body):
	if body.name == "Character":
		var map = maps.instance()
		if body.gunHeld == 1:
			if Global.gunID != null:
				gun = load(Global.gunID.filename)
				var newGun = gun.instance()
				map.add_child(newGun)
				newGun.originallyInScene = false
				newGun.ammo = body.object.ammo
				newGun.clipAmmo = body.object.clipAmmo
			if Global.gunID2 != null:
				gun = load(Global.gunID2.filename)
				var newGun = gun.instance()
				map.add_child(newGun)
				newGun.originallyInScene = false
				newGun.ammo = body.object2.ammo
				newGun.clipAmmo = body.object2.clipAmmo
		elif body.gunHeld == 2:
			if Global.gunID2 != null:
				gun = load(Global.gunID2.filename)
				var newGun = gun.instance()
				map.add_child(newGun)
				newGun.originallyInScene = false
				newGun.ammo = body.object2.ammo
				newGun.clipAmmo = body.object2.clipAmmo
			if Global.gunID != null:
				gun = load(Global.gunID.filename)
				var newGun = gun.instance()
				map.add_child(newGun)
				newGun.originallyInScene = false
				newGun.ammo = body.object.ammo
				newGun.clipAmmo = body.object.clipAmmo
		SceneTransition.fadeIn()
		yield(get_tree().create_timer(1), "timeout")
		get_parent().get_parent().queue_free()
		get_parent().get_parent().get_parent().add_child(map)
		SceneTransition.fadeOut()
