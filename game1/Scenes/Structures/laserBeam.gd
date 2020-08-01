extends Node2D

const MAX_LENGTH = 500


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	$Laser.cast_to.x = MAX_LENGTH
	if $Laser.is_colliding():
		$End.global_position = $Laser.get_collision_point()
	else:
		$End.global_position = $Laser.cast_to
	$Beam.region_rect.end.x = $End.position.length()
	if $Laser.is_colliding():
		if $Laser.get_collider().name == "Character":
			$Laser.get_collider().hit(1, self, false, 1)
		
	
