extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var maxAmmo
var ammo

# Called when the node enters the scene tree for the first time.
func _ready():
	maxAmmo = 0
	ammo = 0
	self.text = "[%s/%s]" % [ammo, maxAmmo]

func getMaxAmmo(mAmmo, Ammo):
	maxAmmo = mAmmo
	ammo = Ammo
	self.text = "[%s/%s]" % [ammo, maxAmmo]

func setAmmo(Ammo):
	ammo = Ammo
	self.text = "[%s/%s]" % [ammo, maxAmmo]
