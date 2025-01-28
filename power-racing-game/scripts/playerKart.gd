extends Kart

@onready var punchfx:PackedScene = preload("res://scenes/punch_fx.tscn")
@export var explosion:PackedScene = preload("res://scenes/explosion.tscn")

var power:int = 1
var powerprogress:int = 0
var powerincrementalgoal:int = 3

func _process(delta):
	if Input.is_action_just_pressed("punch"):
		for node in $Vehicle/DetectPunch.get_overlapping_bodies():
			if not node.get_instance_id() == vehicle.get_instance_id():
				node.velocity += vehicle.global_position.direction_to(node.global_position) * 100
				node.get_parent().health -= ceil((1 * power) / 1.5)
				
				if node.get_parent().health < 1:
					var boom = explosion.instantiate()
					boom.global_position = node.global_position
					get_parent().add_child(boom)
					node.get_parent().queue_free()
				
				var newpunchfx = punchfx.instantiate()
				newpunchfx.global_position = node.global_position
				get_parent().add_child(newpunchfx)
				powerprogress += 1
				if powerprogress == powerincrementalgoal:
					power += 1
					powerprogress = 0
					powerincrementalgoal = floor(power * 3.6)
					var backsprite = load("res://assets/sprite/powerBack" + str(power) + ".png")
					if backsprite:
						$Body/Back2.texture = backsprite
						$Body/Front2.texture = load("res://assets/sprite/powerFront" + str(power) + ".png")
				break
	move_dir = Input.get_action_strength("MoveBackward")
	move_dir -= Input.get_action_strength("MoveForward")
	turn_dir = Input.get_action_strength("TurnLeft")
	turn_dir -= Input.get_action_strength("TurnRight")
	
	$Camera3D.fov = lerp($Camera3D.fov, 90 + (vehicle.velocity.length() / 2.0), 0.15)
	
	$Camera3D.global_transform.origin = lerp($Camera3D.global_transform.origin, $Body/CamGoal.global_transform.origin, 0.2)
	$Camera3D.global_rotation.y = lerp_angle($Camera3D.global_rotation.y, $Body/CamGoal.global_rotation.y, 0.1)
	$TerrainRay.position = $GroundRay.position
	
	if $TerrainRay.is_colliding():
		vehicle.velocity *= 0.7
	
	$Spedometer/Speedometer/SpeedometerDial.rotation = vehicle.velocity.length() / 50.0
	$Spedometer/Speedometer/Speed.text = str(floor(vehicle.velocity.length())) + "m/s"
