extends KinematicBody2D




var screen_size  # Size of the game window.
const gravity = 10
const jump = -200
const acceleration = 10
const stop = 10
const FLOOR = Vector2(0, -1)
var hp
var velocity = Vector2();
var on_ground = false 
var doubleJump = false
var dashReady = false
var init_pos
var freeHand = true 
var moving = false
var animationDirRight = true
var object = null
var can_fire = true 
onready var animationPlayer = $AnimationPlayer
export var speed = 100  # How fast the player will move (pixels/sec).
export var dash = 50  #Currently unused 
export var fire_rate = 0.2
export (int) var knockback

#ready
func _ready():
	init_pos = get_global_transform().origin
	hp = 200
	$CanvasLayer/HealthBar.getMaxHP(200)



#delta
func _physics_process(_delta):
	#move character 
	mousePlace()
	movement()
	pickup()
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

func die():
	set_global_position(init_pos)
	velocity.x = 0
	velocity.y = 0

func handFree():
	freeHand = true
	object = null

func hit(damage, dir, knock):
	hp -= damage
	if dir >= self.global_position.x && knock:
		velocity.x = -knockback
	elif dir <= self.global_position.x && knock:
		velocity.x = knockback
	if hp <= 0:
		
		get_tree().reload_current_scene()
	$CanvasLayer/HealthBar.setHP(hp)
	

func pickup():
	if object != null && Input.is_action_just_pressed("use") && freeHand:
		object.held()
		freeHand = false



func _on_Area2D_body_entered(body):
	if body.has_method("held") && freeHand:
		object = body



func _on_Area2D_body_exited(body):
	if body.has_method("held"):
		object = null
