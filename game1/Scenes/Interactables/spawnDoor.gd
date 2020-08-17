extends Area2D


export (int) var mobsSpawned
export (Resource) var mobType
var mob


# Called when the node enters the scene tree for the first time.
func _ready():
	print(mobType) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_spawnDoor_body_entered(body):
	if body.name == "Character":
		$AnimatedSprite.play("default")



func _on_AnimatedSprite_animation_finished():
	for _i in range(0, mobsSpawned):
		yield(get_tree().create_timer(3), "timeout")
		mob = mobType.instance()
		get_parent().get_parent().get_parent().call_deferred("add_child", mob)
		mob.position = position

