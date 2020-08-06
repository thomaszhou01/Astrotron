extends RigidBody2D


var target
var coin = preload("res://Scenes/Items/Coin.tscn")
var ammo = preload("res://Scenes/Items/Ammo.tscn")
var coin_instance
var ammo_instance
var used
var rng = RandomNumberGenerator.new()

func _input(_event):
	if target != null && Input.is_action_just_pressed("use") && !used:
		$Sprite.frame += 1
		rng.randomize()
		used = true
		$usePrompt.hidePrompt()
		for _i in range(0, rng.randi_range(5, 10)):
			coin_instance = coin.instance()
			get_parent().get_parent().get_parent().call_deferred("add_child", coin_instance)
			coin_instance.position = position
			yield(get_tree().create_timer(0.1), "timeout")
		
		rng.randomize()
		for _i in range(0, rng.randi_range(2, 3)):
			ammo_instance = ammo.instance()
			get_parent().call_deferred("add_child", ammo_instance)
			ammo_instance.position = position
			yield(get_tree().create_timer(0.1), "timeout")




func _on_Area2D_body_entered(body):
	if body.name == "Character" && !used:
		target = body
		$usePrompt.showPrompt()


func _on_Area2D_body_exited(body):
	if body.name == "Character" && !used:
		target = null
		$usePrompt.hidePrompt()
