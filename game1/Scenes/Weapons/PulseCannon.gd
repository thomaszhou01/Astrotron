extends "res://Scenes/Weapons/gunPhysics.gd"



func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func held():
	held = true




func _on_Timer_timeout():
	canShoot = true
