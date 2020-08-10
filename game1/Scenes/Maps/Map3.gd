extends Node


var gun

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.globalGunIDs.size() > 0:
		if Global.globalGunIDs[2] != null:
			gun = load(Global.globalGunIDs[2])
			var newGun = gun.instance()
			self.add_child(newGun)
			newGun.originallyInScene = false
			newGun.ammo =  Global.globalGunAmmos[2]
			newGun.clipAmmo = Global.globalGunClips[2]
			$Character.tempObject = newGun
			$Character.pickup()
		if Global.globalGunIDs[3] != null:
			gun = load(Global.globalGunIDs[3])
			var newGun = gun.instance()
			self.add_child(newGun)
			newGun.originallyInScene = false
			newGun.ammo = Global.globalGunAmmos[3]
			newGun.clipAmmo = Global.globalGunClips[3]
			$Character.tempObject = newGun
			$Character.pickup()

