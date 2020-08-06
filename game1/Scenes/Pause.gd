extends Control


var paused = false
var mute = false



func _ready():
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("escape") && !SceneTransition.animating && (paused == get_tree().paused):
		var pauseState =  not get_tree().paused 
		get_tree().paused = pauseState
		visible = pauseState
		paused = !paused



func _on_Resume_pressed():
	var pauseState =  not get_tree().paused 
	get_tree().paused = pauseState
	visible = pauseState
	paused = !paused


func _on_Quit_pressed():
	get_tree().quit()


func _on_CheckButton_pressed():
	mute = !mute
	AudioServer.set_bus_mute(0, mute)

