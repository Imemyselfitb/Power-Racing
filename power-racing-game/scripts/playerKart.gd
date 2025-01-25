extends Kart

func _process(delta):
	move_dir = Input.get_action_strength("MoveBackward")
	move_dir -= Input.get_action_strength("MoveForward")
	turn_dir = Input.get_action_strength("TurnLeft")
	turn_dir -= Input.get_action_strength("TurnRight")
	
	$Camera3D.fov = lerp($Camera3D.fov, 90 + sqrt(vehicle.velocity.length()), 0.15)
	
	$Camera3D.global_transform.origin = lerp($Camera3D.global_transform.origin, $Body/CamGoal.global_transform.origin, 0.2)
	$Camera3D.global_rotation.y = lerp_angle($Camera3D.global_rotation.y, $Body/CamGoal.global_rotation.y, 0.1)
	$TerrainRay.position = $GroundRay.position
	
	if $TerrainRay.is_colliding():
		vehicle.velocity *= 0.3
