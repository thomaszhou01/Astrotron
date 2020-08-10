extends Node


var gun



# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.globalGunIDs.size() > 0:
		if Global.globalGunIDs[0] != null:
			gun = load(Global.globalGunIDs[0])
			var newGun = gun.instance()
			self.add_child(newGun)
			newGun.originallyInScene = false
			newGun.ammo =  Global.globalGunAmmos[0]
			newGun.clipAmmo = Global.globalGunClips[0]
			$Character.tempObject = newGun
			$Character.pickup()
		if Global.globalGunIDs[1] != null:
			gun = load(Global.globalGunIDs[1])
			var newGun = gun.instance()
			self.add_child(newGun)
			newGun.originallyInScene = false
			newGun.ammo = Global.globalGunAmmos[1]
			newGun.clipAmmo = Global.globalGunClips[1]
			$Character.tempObject = newGun
			$Character.pickup()

