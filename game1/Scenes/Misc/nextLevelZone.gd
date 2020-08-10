extends Area2D


export (Resource) var maps
export (int) var nextLevel
var gun
var gunIndex

# Called when the node enters the scene tree for the first time.
func _ready():
	gunIndex = (nextLevel-1)*2-1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_nextLevelZone_body_entered(body):
	if body.name == "Character":
		var map = load("res://Scenes/Menu.tscn").instance()
		if Global.onLevel < nextLevel:
			Global.onLevel += 1
			#first time add guns
			if Global.gunID != null:
				Global.globalGunIDs.append(Global.gunID.filename)
				Global.globalGunAmmos.append(Global.gunID.ammo)
				Global.globalGunClips.append(Global.gunID.clipAmmo)
			else:
				Global.globalGunIDs.append(null)
				Global.globalGunAmmos.append(0)
				Global.globalGunClips.append(0)
			
			if Global.gunID2 != null:
				Global.globalGunIDs.append(Global.gunID2.filename)
				Global.globalGunAmmos.append(Global.gunID2.ammo)
				Global.globalGunClips.append(Global.gunID2.clipAmmo)
			else:
				Global.globalGunIDs.append(null)
				Global.globalGunAmmos.append(0)
				Global.globalGunClips.append(0)
		else:
			#repeated change guns
			if Global.gunID != null:
				Global.globalGunIDs[gunIndex-1] = (Global.gunID.filename)
				Global.globalGunAmmos[gunIndex-1] = (Global.gunID.ammo)
				Global.globalGunClips[gunIndex-1] = (Global.gunID.clipAmmo)
			else:
				Global.globalGunIDs[gunIndex-1] = (null)
				Global.globalGunAmmos[gunIndex-1] = (0)
				Global.globalGunClips[gunIndex-1] = (0)
			
			if Global.gunID2 != null:
				Global.globalGunIDs[gunIndex] = (Global.gunID2.filename)
				Global.globalGunAmmos[gunIndex] = (Global.gunID2.ammo)
				Global.globalGunClips[gunIndex] = (Global.gunID2.clipAmmo)
			else:
				Global.globalGunIDs[gunIndex] = (null)
				Global.globalGunAmmos[gunIndex] = (0)
				Global.globalGunClips[gunIndex] = (0)
		SceneTransition.fadeIn()
		yield(get_tree().create_timer(1), "timeout")
		get_parent().get_parent().queue_free()
		get_parent().get_parent().get_parent().get_parent().add_child(map)
		map.get_node("AnimationPlayer").play("mapSelect")
		SceneTransition.fadeOut()
