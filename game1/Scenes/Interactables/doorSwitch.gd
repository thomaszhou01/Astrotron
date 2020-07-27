extends Area2D


var object
var used
export (bool) var needsKey


# Called when the node enters the scene tree for the first time.
func _ready():
	used = false


func _input(_event):
	if Input.is_action_just_pressed("use") && object != null && !used  && Global.hasKey && needsKey:
		get_parent().get_node("AnimationPlayer").play("open")
		$Sprite.set_frame(1)
		used = true
		Global.hasKey = false
		$usePrompt.hide()
	elif Input.is_action_just_pressed("use") && object != null && !used && !needsKey:
		get_parent().get_node("AnimationPlayer").play("open")
		$Sprite.set_frame(1)
		used = true
		$usePrompt.hide()

func _on_doorSwitch_body_entered(body):
	if body.name == "Character":
		object = body
		$usePrompt.showPrompt()


func _on_doorSwitch_body_exited(body):
	if body.name == "Character":
		object = null
		$usePrompt.hidePrompt()
