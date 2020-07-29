extends KinematicBody2D

const gravity = 10
const FLOOR = Vector2.UP
const inertia = 50
var bullet = preload("res://Scenes/bullet.tscn")
var coin = preload("res://Scenes/Items/Coin.tscn")
var ammo = preload("res://Scenes/Items/Ammo.tscn")
var velocity = Vector2();
var patroling = true
var initPos
var detected = false
var coin_instance
var rng = RandomNumberGenerator.new()
export (int) var damage
export (int) var hp
export (int) var speed
export (int) var patrolRange
export (int) var coinsDropped

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func dropAmmo(highNum):
	rng.randomize()
	var num = rng.randi_range(0, highNum)
	if num == 0:
		var ammo_instance = ammo.instance()
		get_parent().get_parent().get_parent().call_deferred("add_child", ammo_instance)
		ammo_instance.position = position
