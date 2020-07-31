extends Node


var gun1
var gun1Ammo
var gun1clipAmmo
var gun2
var gun2Ammo
var gun2clipAmmo


# Called when the node enters the scene tree for the first time.
func _ready():
	if gun1 != null:
		gun1 = load(Global.gunID.filename)
		var newGun = gun1.instance()
		self.add_child(newGun)
		newGun.originallyInScene = false
		newGun.ammo = gun1Ammo
		newGun.clipAmmo = gun1clipAmmo
	if gun2 != null:
		gun2 = load(Global.gunID2.filename)
		var newGun = gun2.instance()
		self.add_child(newGun)
		newGun.originallyInScene = false
		newGun.ammo = gun2Ammo
		newGun.clipAmmo = gun2clipAmmo


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
