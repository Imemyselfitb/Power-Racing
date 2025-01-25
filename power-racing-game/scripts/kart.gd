extends Node3D

@onready var body = $Body
@onready var vehicle = $Vehicle

var accel: float = 12000
var steer: float = 40.0 * PI / 180
var turn_stop_limit: float = 0.3
var grip = 0.7

var turnvel:float = 0

func _physics_process(delta: float) -> void:
	var move_dir: float = Input.get_action_strength("MoveBackward")
	move_dir -= Input.get_action_strength("MoveForward")
	move_dir *= accel
	
	var turn_dir: float = Input.get_action_strength("TurnLeft")
	turn_dir -= Input.get_action_strength("TurnRight")
	turn_dir *= steer
	
	$Body/FrontWheels.rotation.y = lerp($Body/FrontWheels.rotation.y, turn_dir / 2.0, 0.5)
	turn_dir *= sign(-move_dir)
	
	turnvel = lerp(turnvel, turn_dir, 0.1)
	
	if $GroundRay.is_colliding():
		var force: float = clamp(vehicle.linear_velocity.length(), 0, 1) * delta
		var new_basis: Basis = body.global_transform.basis.rotated(body.global_transform.basis.y, turnvel)
		body.global_transform.basis = body.global_transform.basis.slerp(new_basis, 0.99 * delta)
		body.global_transform = body.global_transform.orthonormalized()
	
	var degree:Vector3 = Vector3.FORWARD.rotated(Vector3.UP, body.rotation.y)
	var drift:float = degree.signed_angle_to(vehicle.linear_velocity, Vector3.UP)
	body.transform.origin = vehicle.transform.origin
	print(sqrt(abs((drift) / PI) * grip))
	if move_dir < 1:
		vehicle.linear_velocity.x *= 1 -(abs((drift) / PI) * grip)
		vehicle.linear_velocity.z *=  1 -(abs((drift) / PI) * grip)
	vehicle.apply_central_force(body.global_transform.basis.z * move_dir)
