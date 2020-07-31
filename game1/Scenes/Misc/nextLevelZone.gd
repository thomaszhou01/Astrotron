extends Area2D


export (Resource) var maps
var gun

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_nextLevelZone_body_entered(body):
	if body.name == "Character":
		var map = maps.instance()
		if Global.gunID != null:
			map.gun1 = load(Global.gunID.filename)
			map.gun1Ammo = body.object.ammo
			map.gun1clipAmmo = body.object.clipAmmo
		if Global.gunID2 != null:
			map.gun2 = load(Global.gunID2.filename)
			map.gun2Ammo = body.object2.ammo
			map.gun2clipAmmo = body.object2.clipAmmo
		SceneTransition.fadeIn()
		yield(get_tree().create_timer(1), "timeout")
		get_parent().get_parent().queue_free()
		get_parent().get_parent().get_parent().add_child(map)
		SceneTransition.fadeOut()
