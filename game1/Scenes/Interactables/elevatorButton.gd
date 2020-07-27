extends Area2D


var object

func _process(delta):
	$Sprite.set_frame(4+get_parent().buttonLight)
	if get_parent().buttonLight == 0:
		$usePrompt.show()
	else:
		$usePrompt.hide()

#fix to allow both directions
func _input(event):
	if object != null && Input.is_action_just_pressed("use") && get_parent().goingUP && get_parent().useButton:
		get_parent().goUp()
	elif object != null && Input.is_action_just_pressed("use") && !get_parent().goingUP && get_parent().useButton: 
		get_parent().goDown()


func _on_elevatorButton_body_entered(body):
	if body.name == "Character":
		object = body
		$usePrompt.showPrompt()


func _on_elevatorButton_body_exited(body):
	if body.name == "Character":
		object = null
		$usePrompt.hidePrompt()
