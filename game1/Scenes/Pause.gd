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



func _on_Menu_pressed():
	if get_parent().get_parent().get_node("Worlds").get_child_count() > 0:
		var map = load("res://Scenes/Menu.tscn").instance()
		SceneTransition.fadeIn()
		var pauseState =  not get_tree().paused 
		get_tree().paused = pauseState
		visible = pauseState
		paused = !paused
		
		yield(get_tree().create_timer(1), "timeout")
		get_parent().get_parent().get_node("Worlds").get_child(0).queue_free()
		get_parent().get_parent().add_child(map)
		SceneTransition.fadeOut()
