extends Area2D

var object
export (int) var levels
export (int) var width


#get tileset tile to be ladder 4head
func _ready():
	$CollisionShape2D.shape.extents.y = levels * 8
	$CollisionShape2D.shape.extents.x = (width+1) * 8


func _input(_event):
	if object != null && (Input.is_action_pressed("up") || Input.is_action_pressed("down")):
		object.onLadder = true
	


func _on_ladder_body_entered(body):
	if body.name == "Character":
		object = body


func _on_ladder_body_exited(body):
	if body.name == "Character":
		body.onLadder = false
		object = null
