extends KinematicBody2D

const gravity = 50
const speed = 60
const FLOOR = Vector2(0, -1)
var bullet = preload("res://Scenes/bullet.tscn")
var velocity = Vector2();


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
