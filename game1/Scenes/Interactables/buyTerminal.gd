extends Area2D


var object
var inWindow = false
export (int) var gunNumb
export (bool) var sellsShields
var source 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _input(event):
	if Input.is_action_just_pressed("use") && !SceneTransition.animating && object != null:
		var pauseState =  not get_tree().paused 
		get_tree().paused = pauseState
		inWindow = pauseState
		if pauseState:
			$AnimationPlayer.play("load")
			source = load("res://Resources/Audio/Interactables/itemback.wav")
			$effects.set_stream(source)
			$effects.play()
		else:
			$AnimationPlayer.play("unload")
			source = load("res://Resources/Audio/Interactables/itempick1.wav")
			$effects.set_stream(source)
			$effects.play()


func _on_buyTerminal_body_entered(body):
	if body.name == "Character":
		object = body
		$usePrompt.showPrompt()


func _on_buyTerminal_body_exited(body):
	if body.name == "Character":
		object = null
		$usePrompt.hidePrompt()

