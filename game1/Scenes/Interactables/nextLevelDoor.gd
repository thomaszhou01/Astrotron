extends Area2D


var object
export (Resource) var maps
var gun


#get the ID of the gun the player is holding and store as global value
func _input(event):
	if Input.is_action_just_pressed("use") && object != null:
		var map = maps.instance()
		if Global.gunID != null:
			map.gun1 = load(Global.gunID.filename)
			map.gun1Ammo = object.object.ammo
			map.gun1clipAmmo = object.object.clipAmmo
		if Global.gunID2 != null:
			map.gun2 = load(Global.gunID2.filename)
			map.gun2Ammo = object.object2.ammo
			map.gun2clipAmmo = object.object2.clipAmmo
		SceneTransition.fadeIn()
		yield(get_tree().create_timer(1), "timeout")
		get_parent().get_parent().queue_free()
		get_parent().get_parent().get_parent().add_child(map)
		SceneTransition.fadeOut()

func _on_nextLevelDoor_body_entered(body):
	if body.name == "Character":
		object = body
		$usePrompt.showPrompt()


func _on_nextLevelDoor_body_exited(body):
	if body.name == "Character":
		object = null
		$usePrompt.hidePrompt()
