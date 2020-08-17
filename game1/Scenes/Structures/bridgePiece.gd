extends RigidBody2D


export (int) var maxHP
var hp


# Called when the node enters the scene tree for the first time.
func _ready():
	hp = maxHP


func hit(damage, hitBy, knock, type):
	hp -= damage
	if hp <= 0:
		get_parent().detach(self)
