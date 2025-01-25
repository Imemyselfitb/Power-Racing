extends Node3D

@onready var body = $Body
@onready var vehicle = $Vehicle

var accel: float = 500
var steer: float = 50.0 * PI / 180
var turn_stop_limit: float = 0.3

var turnvel:float = 0

func _physics_process(delta: float) -> void:
	var move_dir: float = Input.get_action_strength("MoveBackward")
	move_dir -= Input.get_action_strength("MoveForward")
	move_dir *= accel
	
	var turn_dir: float = Input.get_action_strength("TurnLeft")
	turn_dir -= Input.get_action_strength("TurnRight")
	turn_dir *= steer
	turn_dir *= sign(-move_dir)
	if vehicle.linear_velocity.length() > turn_stop_limit:
		var force: float = clamp(vehicle.linear_velocity.length(), 0, 1) * delta
		var new_basis: Basis = body.global_transform.basis.rotated(body.global_transform.basis.y, turn_dir)
		body.global_transform.basis = body.global_transform.basis.slerp(new_basis, 0.8 * delta)
		body.global_transform = body.global_transform.orthonormalized()
	
	body.transform.origin = vehicle.transform.origin
	vehicle.apply_central_force(body.global_transform.basis.z * move_dir)
	if move_dir == 0:
		vehicle.linear_velocity.x *= 0.99
		# (Keep vertical velocity the same)
		vehicle.linear_velocity.z *= 0.99
