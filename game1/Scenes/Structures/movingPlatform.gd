extends Node2D

export (float) var dist
export (int) var idle
var moveTo
var duration 
var speed = 3
var currentPos
var follow = Vector2.ZERO

onready var tween = $Move 
onready var platform = $platform


# Called when the node enters the scene tree for the first time.
func _ready():
	moveTo = Vector2.RIGHT * dist
	move()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func move():
	duration = moveTo.length() / float(speed * 16)
	tween.interpolate_property(self, "follow", Vector2.ZERO, moveTo, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, idle)
	tween.interpolate_property(self, "follow", moveTo, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + idle*2)
	tween.start()

func _physics_process(delta):
	platform.position = platform.position.linear_interpolate(follow, .075)
