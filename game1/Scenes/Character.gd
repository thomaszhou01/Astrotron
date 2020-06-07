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
var moving = false
var animationDirRight = true

onready var animationPlayer = $AnimationPlayer
var can_fire = true 
var railgun = preload("res://Scenes/Weapons/RailGun.tscn")


#ready
func _ready():
	init_pos = get_global_transform().origin



#delta
func _physics_process(_delta):
	#move character 
	mousePlace()
	movement()
	velocity = move_and_slide(velocity, FLOOR)

func mousePlace():
	if get_viewport().get_mouse_position().x > (get_viewport_rect().size.x/2):
		animationDirRight = true
	else: 
		animationDirRight = false

func movement():
	if Input.is_action_pressed("move_right") && abs(velocity.x) < speed:
		moving = true
		velocity.x += acceleration
	elif Input.is_action_pressed("move_left")&& abs(velocity.x) < speed:
		moving = true
		velocity.x += -acceleration
	else:
		if velocity.x > 0:
			velocity.x += -stop
		elif velocity.x < 0:
			velocity.x += stop
	
	#fix this 
	if abs(velocity.x) < 10:
		velocity.x = 0
		moving = false
	
	if animationDirRight && moving:
		animationPlayer.play("RunRight")
	elif !animationDirRight && moving:
		animationPlayer.play("RunLeft")
	elif animationDirRight  && !moving:
			animationPlayer.play("IdleRight")
	elif !animationDirRight  && !moving:
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
		

func die():
	set_global_position(init_pos)
	velocity.x = 0
	velocity.y = 0

func handFree():
	$holdPoint.position.y = 2
	freeHand = true


func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	if ("RailGun" in body.name || "PulseCannon" in body.name || "Gun" in body.name) && freeHand:
		body.held()
		freeHand = false
