extends Control

onready var health_bar = $HealthBar
onready var health_under = $HealthUnder
onready var tween = $Update

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getMaxHP(maxHP):
	health_bar.max_value = maxHP
	health_bar.value = maxHP
	health_under.max_value = maxHP
	health_under.value = maxHP

func setHP(hp):
	health_bar.value = hp
	tween.interpolate_property(health_under, "value", health_under.value, hp, .6, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
