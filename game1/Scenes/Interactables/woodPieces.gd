extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()


func _on_Timer_timeout():
	$Tween.interpolate_property($Sprite, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.call_deferred("start")


func _on_Tween_tween_completed(object, key):
	queue_free()
