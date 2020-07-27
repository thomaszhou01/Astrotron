extends Control

onready var reload_bar = $ReloadBar
onready var tween = $Update

export (Color) var barColour

# Called when the node enters the scene tree for the first time.
func _ready():
	reload_bar.set_tint_progress(barColour)

func getMaxReloadTime(maxReload):
	reload_bar.max_value = maxReload
	reload_bar.value = maxReload

func setReload(time):
	reload_bar.value = time
