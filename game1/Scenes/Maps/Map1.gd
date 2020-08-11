extends Node

var gun
var gunClip = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	gun = load("res://Scenes/Weapons/Gun.tscn")
	var newGun = gun.instance()
	self.add_child(newGun)
	newGun.originallyInScene = false
	newGun.ammo =  gunClip
	newGun.clipAmmo = gunClip * 5
	$Character.tempObject = newGun
	$Character.pickup()
