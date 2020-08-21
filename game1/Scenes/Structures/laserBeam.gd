extends Node2D

const MAX_LENGTH = 600
export (bool) var pulse
export (int) var displayLength
export (int) var offsetTime
var active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if pulse:
		yield(get_tree().create_timer(offsetTime), "timeout")
		$Timer.start()
		$Timer.wait_time = displayLength


func _physics_process(delta):
	$Laser.cast_to.x = MAX_LENGTH
	if $Laser.is_colliding():
		$End.global_position = $Laser.get_collision_point()
	else:
		$End.global_position = $Laser.cast_to
	$Beam.region_rect.end.x = $End.position.length()
	if $Laser.is_colliding():
		if $Laser.get_collider().name == "Character":
			$Laser.get_collider().hit(5, self, false, 1)


func _on_Timer_timeout():
	if active:
		$Laser.enabled = false
		$Beam.visible = false
	else:
		$Laser.enabled = true
		$Beam.visible = true
	active = !active
