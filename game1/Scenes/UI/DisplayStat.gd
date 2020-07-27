extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var maxHp
var hp

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func assign(HP, maxHP):
	hp = HP
	maxHp = maxHP
	self.text = "%s/%s" % [hp, maxHp]

func getValue(HP):
	hp = HP
	self.text = "%s/%s" % [hp, maxHp]

func setCoin():
	self.text = "%s" % [Global.money]
