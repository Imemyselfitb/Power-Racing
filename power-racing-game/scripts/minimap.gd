extends Control

@export var zoomOut: float = 1
@export var path3d: Path3D = null

@export var Level: Node3D = null

@export var offset: Vector2

var enemyIcon: Texture2D = load("res://assets/gui/MinimapEnemyIcon.png")
var playerIcon: Texture2D = load("res://assets/gui/MinimapPlayerIcon.png")

var kartAI_List: Array[Node3D]
var kartAI_Icons: Array[Sprite2D]

var player: Node3D
var player_Icon: Sprite2D

func getPosition(vec3: Vector3):
	return Vector2(vec3.x, vec3.z) * zoomOut

func _ready() -> void:
	assert(path3d != null, "ERROR: PATH 3D Not Selected for Minimap Node!")
	
	var average_pt: Vector2 = Vector2(0,0)
	for i in range(path3d.curve.point_count):
		#var pos3d: Vector3 = path3d.curve.get_point_position(i) * zoomOut
		#var pos: Vector2 = Vector2(pos3d.x, pos3d.z)
		var pos: Vector2 = getPosition(path3d.curve.get_point_position(i))
		$Node2D/Path2D.curve.add_point(pos)
		$Node2D/Line2D.add_point(pos)
		$Node2D/Line2D2.add_point(pos)
		
		average_pt += pos
	
	$Node2D.position = (size * 0.5) - (average_pt / path3d.curve.point_count) + offset
	
	for child in Level.get_children(false):
		if child.name.contains("Player"):
			player = child.get_node("Vehicle")
			player_Icon = Sprite2D.new()
			player_Icon.texture = playerIcon
			player_Icon.position = getPosition(player.global_position)
			player_Icon.scale *= 0.5
			$Node2D.add_child(player_Icon)
			
		elif child.name.contains("Kart"):
			var vehicle: Node3D = child.get_node("Vehicle")
			kartAI_List.push_back(vehicle)
			var icon: Sprite2D = Sprite2D.new()
			icon.texture = enemyIcon
			icon.position = getPosition(vehicle.global_position)
			icon.scale *= 0.4
			$Node2D.add_child(icon)
			kartAI_Icons.push_back(icon)

func _physics_process(_delta: float) -> void:
	player_Icon.position = getPosition(player.global_position)
	
	for i in range(len(kartAI_List) - 1, -1, -1):
		if !is_instance_valid(kartAI_List[i]):
			kartAI_Icons[i].queue_free()
			kartAI_Icons.remove_at(i)
			kartAI_List.remove_at(i)
			continue
		
		kartAI_Icons[i].position = getPosition(kartAI_List[i].global_position)
