extends "res://Scenes/mainScript.gd"



export (bool) var devMode
var x

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Default")
	if Global.onLevel == 2:
		$CanvasLayer/MapSelect/map2.disabled = false
	if Global.onLevel == 3:
		$CanvasLayer/MapSelect/map2.disabled = false
		$CanvasLayer/MapSelect/map3.disabled = false

func _on_TextureButton_pressed():
	$AnimationPlayer.play("ToMapSelect")


func _on_map1_pressed():
	$Tween.interpolate_property($MenuMusic, "volume_db", -5, -20, 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.start()
	if devMode:
		x = test.instance()
	else:
		x = load("res://Scenes/Maps/Map1.tscn").instance()
	SceneTransition.fadeIn()
	yield(get_tree().create_timer(1), "timeout")
	get_parent().get_node("Worlds").add_child(x)
	queue_free()
	SceneTransition.fadeOut()


func _on_map2_pressed():
	$Tween.interpolate_property($MenuMusic, "volume_db", -5, -20, 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.start()
	x = load("res://Scenes/Maps/Map2.tscn").instance()
	SceneTransition.fadeIn()
	yield(get_tree().create_timer(1), "timeout")
	get_parent().get_node("Worlds").add_child(x)
	queue_free()
	SceneTransition.fadeOut()


func _on_map3_pressed():
	$Tween.interpolate_property($MenuMusic, "volume_db", -5, -20, 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.start()
	if devMode:
		x = test.instance()
	else:
		x = load("res://Scenes/Maps/Map3.tscn").instance()
	SceneTransition.fadeIn()
	yield(get_tree().create_timer(1), "timeout")
	get_parent().get_node("Worlds").add_child(x)
	queue_free()
	SceneTransition.fadeOut()
