extends Node3D

@onready var body = $Body
@onready var vehicle = $Vehicle

var accel: float = 50
var steer: float = 50.0 * PI / 180
var turn_stop_limit: float = 0.5

func _physics_process(delta: float) -> void:
	var turn_dir: float = Input.get_action_strength("TurnLeft")
	turn_dir -= Input.get_action_strength("TurnRight")
	var move_dir: float = Input.get_action_strength("MoveBackward")
	move_dir -= Input.get_action_strength("MoveForward")
	turn_dir *= steer
	move_dir *= accel
	if move_dir == 0:
		vehicle.linear_velocity *= 0.8
	
	body.transform.origin = vehicle.transform.origin
	vehicle.apply_central_force(body.global_transform.basis.z * move_dir)
	
	if vehicle.linear_velocity.length() > turn_stop_limit:
		var new_basis: Basis = body.global_transform.basis.rotated(body.global_transform.basis.y, turn_dir)
		body.global_transform.basis = body.global_transform.basis.slerp(new_basis, delta)
		body.global_transform = body.global_transform.orthonormalized()
