extends Area2D


func _on_RespawnPointSet_body_entered(body):
	Global.respawnLoc = get_global_transform().origin
