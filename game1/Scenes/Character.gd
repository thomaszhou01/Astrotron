extends KinematicBody2D



export var speed = 100  # How fast the player will move (pixels/sec).
export var dash = 50  
export var fire_rate = 0.2
var screen_size  # Size of the game window.
const gravity = 10
const jump = -200
const acceleration = 10
const stop = 10
const FLOOR = Vector2(0, -1)
var velocity = Vector2();
var on_ground = false 
var doubleJump = false
var dashReady = false
var init_pos
var freeHand = true 

onready var animationPlayer = $AnimationPlayer
var can_fire = true 
var railgun = preload("res://Scenes/Weapons/RailGun.tscn")


#ready
func _ready():
	init_pos = get_global_transform().origin



#delta
func _physics_process(_delta):
	#move character 
	if Input.is_action_pressed("move_right") && abs(velocity.x) < speed:
		animationPlayer.play("RunRight")
		velocity.x += acceleration
		if sign($holdPoint.position.x) == -1:
			$holdPoint.position.x *= -1
	elif Input.is_action_pressed("move_left")&& abs(velocity.x) < speed:
		animationPlayer.play("RunLeft")
		velocity.x += -acceleration
		if sign($holdPoint.position.x) == 1:
			$holdPoint.position.x *= -1
	else:
		if velocity.x > 0:
			velocity.x += -stop
		elif velocity.x < 0:
			velocity.x += stop
	
	if abs(velocity.x) < 10:
		velocity.x = 0
		if sign($holdPoint.position.x) == 1:
			animationPlayer.play("IdleRight")
		else:
			animationPlayer.play("IdleLeft")
	
	velocity.y += gravity
	
	if is_on_floor():
		on_ground = true
		doubleJump = true
		dashReady = true 
	else: 
		on_ground = false
	
	if Input.is_action_just_pressed("jump") && on_ground:
		velocity.y = jump
		on_ground = false
	elif Input.is_action_just_pressed("jump") && doubleJump:
		velocity.y = jump
		doubleJump = false
	
	
	if Input.is_action_just_pressed("dash") && dashReady:
		velocity.x = 80*$holdPoint.position.x
		velocity.y = -200
		dashReady = false 
		
	if abs(velocity.x)>0:
		pass
	else:
		pass
	
	
	velocity = move_and_slide(velocity, FLOOR)


func die():
	set_global_position(init_pos)
	velocity.x = 0
	velocity.y = 0

func handFree():
	$holdPoint.position.y = 2
	freeHand = true

func _on_Area2D_body_entered(body):
	if ("RailGun" in body.name || "PulseCannon" in body.name) && freeHand:
		body.held()
		freeHand = false
