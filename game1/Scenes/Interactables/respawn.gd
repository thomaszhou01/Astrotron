extends Area2D

func _ready():
	pass


#get the position of the character and teleport to that one
func _input(event):
	if Input.is_action_just_pressed("use") && Global.respawnHover == self:
		Global.respawnLoc = self.global_position
		$Sprite.set_frame(1)
		$usePrompt.hide()
	elif Input.is_action_just_pressed("use") && Global.respawnHover != null:
		$Sprite.set_frame(0)
		$usePrompt.show()



func _on_respawn_body_entered(body):
	if body.has_method("pickup"):
		Global.respawnHover = self
		$usePrompt.showPrompt()



func _on_respawn_body_exited(body):
	if body.has_method("pickup"):
		Global.respawnHover = null
		$usePrompt.hidePrompt()
