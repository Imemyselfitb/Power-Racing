extends Node3D

##Will Avoid if something is detected
@export var LeftRayAvoid:Node3D
##Will Avoid if something is detected
@export var RightRayAvoid:Node3D
##Will Avoid if nothing is detected
@export var LeftRayVoid:Node3D
##Will Avoid if nothing is detected
@export var RightRayVoid:Node3D

@export var flinch:float = 1

@export var path:Path3D = null
var pathfollow:PathFollow3D = PathFollow3D.new()

@onready var vehicle:Node3D = $Vehicle
@onready var body:Node3D = $Body

@export var speed:float = 172
@export var turnspeed:float = 30

var gravity = 9

var health:int = 3

func _ready():
	for ray in $Body/Rays.get_children():
		ray.add_exception(vehicle)
	speed += randf_range(-2, 2)
	turnspeed = 8000 / speed
	flinch = randf_range(0.8, 1.7)
	
	path.add_child(pathfollow)
	pathfollow.use_model_front = true

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform.orthonormalized()

var grip:float = 0.9

func _physics_process(delta):
	$Body/AudioStreamPlayer3D2.pitch_scale = vehicle.velocity.length() / 20.0
	
	vehicle.velocity.x *= grip
	vehicle.velocity.z *= grip
	pathfollow.progress = path.curve.get_closest_offset(vehicle.global_position)
	$GroundRay/Look.look_at(pathfollow.global_position)
	$GroundRay/Look.rotation.x = 0
	$GroundRay/Look.rotation.z = 0
	var goaway:Vector3 = Vector3.ZERO
	for ray in $Body/Rays.get_children():
		if ray.is_colliding():
			goaway -= (ray.get_collision_point() - vehicle.global_position).normalized() * flinch
	goaway.y = 0
	var turn = $GroundRay/Look.global_transform.basis.z * turnspeed * delta
	if vehicle.velocity.length() < 600:
		vehicle.velocity += pathfollow.global_transform.basis.z * speed * delta
	vehicle.velocity -= turn
	$Body/FrontWheels.rotation.y = (vehicle.velocity.x * vehicle.velocity.z) / speed / 2.3
	vehicle.velocity += goaway
	$GroundRay/Look.look_at(vehicle.global_position)
	body.rotation.y = lerp_angle(body.rotation.y, $GroundRay/Look.rotation.y, 12 * delta)
	
	var wheelspeed:float = vehicle.velocity.length() / 170.0
	
	$Body/FrontWheels/FrontL/WheelControl.rotation.x += wheelspeed
	$Body/FrontWheels/FrontR/WheelControl.rotation.x += wheelspeed
	$Body/BackL/WheelControl.rotation.x += wheelspeed
	$Body/BackR/WheelControl.rotation.x += wheelspeed
	$GroundRay.position = $Vehicle.position
	$TerrainRay.position = $GroundRay.position
	
	if $TerrainRay.is_colliding():
		vehicle.velocity *= 0.9
	
	if $GroundRay.get_collider() or (vehicle.is_on_floor() or vehicle.is_on_wall()):
		$Body.global_position = $GroundRay.get_collision_point()
	else:
		$Body.global_position = $Vehicle.global_position
	
	if $GroundRay.is_colliding():
		var force: float = clamp(vehicle.velocity.length(), 0, 1) * delta
		var n = $GroundRay.get_collision_normal()
		var xform = align_with_y(body.global_transform, n)
		body.global_transform = body.global_transform.interpolate_with(xform, 10.0 * delta)
	
	if vehicle.is_on_wall() and vehicle.is_on_floor():
		vehicle.position.y += 0.6
	
	if not vehicle.is_on_floor():
		vehicle.velocity.y -= gravity * delta
	
	vehicle.move_and_slide()
