extends Control

onready var health_bar = $HealthBar
onready var health_under = $HealthUnder
onready var tween = $Update

export (Color) var barColour = Color.green

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.set_tint_progress(barColour)

func getMaxHP(maxHP):
	health_bar.max_value = maxHP
	health_bar.value = maxHP
	health_under.max_value = maxHP
	health_under.value = maxHP

func setHP(hp):
	health_bar.value = hp
	tween.interpolate_property(health_under, "value", health_under.value, hp, .6, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()

func revive(time):
	tween.interpolate_property(health_bar, "value", health_bar.value, health_bar.max_value, time, Tween.TRANS_SINE, Tween.EASE_OUT)
