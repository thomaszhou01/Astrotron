extends CanvasLayer


var animating 


# Called when the node enters the scene tree for the first time.
func _ready():
	animating = false


func fadeIn():
	$ColorRect.visible = true
	animating = true
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")

func fadeOut():
	$AnimationPlayer.play_backwards("fade")
	yield($AnimationPlayer, "animation_finished")
	animating = false
	$ColorRect.visible = false
