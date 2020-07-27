extends Area2D


var object
export (Resource) var maps
var gun


#get the ID of the gun the player is holding and store as global value
func _input(event):
	if Input.is_action_just_pressed("use") && object != null:
		var map = maps.instance()
		if Global.gunID != null:
			gun = load(Global.gunID)
			var newGun = gun.instance()
			map.add_child(newGun)
			newGun.originallyInScene = false
			newGun.ammo = object.object.ammo
			newGun.clipAmmo = object.object.clipAmmo
		SceneTransition.fadeIn()
		yield(get_tree().create_timer(1), "timeout")
		get_parent().get_parent().queue_free()
		get_parent().get_parent().get_parent().get_parent().add_child(map)
		SceneTransition.fadeOut()

func _on_nextLevelDoor_body_entered(body):
	if body.name == "Character":
		object = body
		$usePrompt.showPrompt()


func _on_nextLevelDoor_body_exited(body):
	if body.name == "Character":
		object = null
		$usePrompt.hidePrompt()
