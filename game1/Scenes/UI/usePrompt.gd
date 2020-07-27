extends Node2D


var showTime


# Called when the node enters the scene tree for the first time.
func _ready():
	showTime = .3
	$Sprite.modulate = Color(1,1,1,0)


func showPrompt():
	$Tween.interpolate_property($Sprite, "modulate", Color(1,1,1,0), Color(1,1,1,1), showTime, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()

func hidePrompt():
	$Tween.interpolate_property($Sprite, "modulate", Color(1,1,1,1), Color(1,1,1,0), showTime, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.call_deferred("start")
