extends Node2D

export (float) var dist
export (bool) var autoStart
var moveTo 
var speed = 10
var object = null
var duration 
var goingUP = true
var currentPos
var useButton 
var buttonLight
var follow = Vector2.ZERO

onready var tween = $Move 
onready var platform = $platform

func _ready():
	moveTo = Vector2.UP*dist
	$platform/AnimatedSprite.play("idle")
	buttonLight = 0
	if autoStart:
		goUp()
	


func goUp():
	duration = (moveTo.length()) / float(speed * 16)
	tween.interpolate_property(self, "follow", Vector2.ZERO, moveTo, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	goingUP = false



func goDown():
	duration = (moveTo.length()) / float(speed * 16)
	tween.interpolate_property(self, "follow", moveTo, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	goingUP = true



func _physics_process(delta):
	
	platform.position = platform.position.linear_interpolate(follow, 0.2)
	currentPos = Vector2(round(platform.position.x), round(platform.position.y))
	
	if object != null && Input.is_action_just_pressed("use") && goingUP && useButton:
		goUp()
	elif object != null && Input.is_action_just_pressed("use") && !goingUP && useButton: 
		goDown()
	

func _process(delta):
	if currentPos == Vector2.ZERO || currentPos == moveTo:
		buttonLight = 0
		$platform/AnimatedSprite.play("idle")
		useButton = true
		$platform/usePrompt.show()
	else:
		$platform/AnimatedSprite.play("moving")
		useButton = false
		$platform/usePrompt.hide()
		if sign(dist) == 1:
			if goingUP:
				buttonLight = 2
			else:
				buttonLight = 1
		else: 
			if goingUP:
				buttonLight = 1
			else:
				buttonLight = 2

func _on_Button_body_entered(body):
	if body.name == "Character":
		object = body
		$platform/usePrompt.showPrompt()


func _on_Button_body_exited(body):
	if body.name == "Character":
		object = null
		$platform/usePrompt.hidePrompt()


func _on_DieZone_body_entered(body):
	if body.name == "Character":
		body.die()
