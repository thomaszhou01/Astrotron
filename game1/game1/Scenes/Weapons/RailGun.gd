extends "res://Scenes/Weapons/gunPhysics.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



#collision box not working/sticking to railgun

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func held():
	held = true
	$Sprite.offset.x = 5



func _on_Timer_timeout():
	canShoot = true
