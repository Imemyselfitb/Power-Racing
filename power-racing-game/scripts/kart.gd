extends Node3D
class_name Kart

@onready var body = $Body
@onready var vehicle = $Vehicle

var accel: float = 1.2
var steer: float = 40.0 * PI / 180
var turn_stop_limit: float = 0.3
var grip = 0.7

var move_dir:float = 0
var turn_dir:float = 0

var turnvel:float = 0

var gravity = 9

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform.orthonormalized()

func _physics_process(delta: float) -> void:
	move_dir *= accel
	
	turn_dir *= steer
	
	$Body/FrontWheels.rotation.y = lerp($Body/FrontWheels.rotation.y, turn_dir / 2.0, 0.5)
	turn_dir *= sign(-move_dir)
	
	turnvel = lerp(turnvel, turn_dir, 0.1)
	
	var degree:Vector3 = Vector3.FORWARD.rotated(Vector3.UP, body.rotation.y)
	var drift:float = degree.signed_angle_to(vehicle.velocity, Vector3.UP)
	if $GroundRay.get_collider() or (vehicle.is_on_floor() or vehicle.is_on_wall()):
		$Body.global_position = $GroundRay.get_collision_point()
	else:
		$Body.global_position = $Vehicle.global_position
	
	var grifp:float = 1 -(abs((drift) / PI) * grip)
	var wheelspeed:float = vehicle.velocity.length() / 170.0
	
	$Body/FrontWheels/FrontL/WheelControl.rotation.x += wheelspeed
	$Body/FrontWheels/FrontR/WheelControl.rotation.x += wheelspeed
	$Body/BackL/WheelControl.rotation.x += wheelspeed
	$Body/BackR/WheelControl.rotation.x += wheelspeed
	$GroundRay.position = $Vehicle.position
	
	if $GroundRay.is_colliding():
		var force: float = clamp(vehicle.velocity.length(), 0, 1) * delta
		var new_basis: Basis = body.global_transform.basis.rotated(body.global_transform.basis.y, turnvel)
		body.global_transform.basis = body.global_transform.basis.slerp(new_basis, 0.99 * delta)
		body.global_transform = body.global_transform.orthonormalized()
		if abs(drift) > PI / 2.0:
			print("drift")
		var n = $GroundRay.get_collision_normal()
		var xform = align_with_y(body.global_transform, n)
		body.global_transform = body.global_transform.interpolate_with(xform, 10.0 * delta)
		if move_dir < 1:
			vehicle.velocity.x *= grifp
			vehicle.velocity.z *=  grifp
		vehicle.velocity += (body.global_transform.basis.z * move_dir)
	
	if vehicle.is_on_wall() and vehicle.is_on_floor():
		vehicle.position.y += 0.6
	
	if not vehicle.is_on_floor():
		vehicle.velocity.y -= gravity * delta
	
	vehicle.move_and_slide()
