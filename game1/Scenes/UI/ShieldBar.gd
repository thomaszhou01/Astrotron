extends Control

onready var shield_bar = $ShieldBar
onready var shield_under = $ShieldUnder
onready var tween = $Update

export (Color) var barColour

# Called when the node enters the scene tree for the first time.
func _ready():
	shield_bar.set_tint_progress(barColour)

func getMaxShield(maxHP):
	shield_bar.max_value = maxHP
	shield_bar.value = maxHP
	shield_under.max_value = maxHP
	shield_under.value = maxHP

func setShield(hp):
	shield_bar.value = hp
	tween.interpolate_property(shield_under, "value", shield_under.value, hp, .6, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
