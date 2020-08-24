extends Area2D


export (int) var mobsSpawned
export (Resource) var mobType
var mob


func _on_spawnDoor_body_entered(body):
	if body.name == "Character":
		$AnimatedSprite.play("default")



func _on_AnimatedSprite_animation_finished():
	for _i in range(0, mobsSpawned):
		yield(get_tree().create_timer(1), "timeout")
		mob = mobType.instance()
		get_parent().call_deferred("add_child", mob)
		mob.position = position

