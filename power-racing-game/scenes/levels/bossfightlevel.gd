extends Node3D

@onready var time:float = 180 # 3 mins

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@export var playerKart: Kart

var raceEnded: bool = false

var distanceTraveled: float = 0
var lastDistance: float = 0

var moneyvirtual: int = 0
var moneytotal: int = 0

var winTime: int = 0
var won = false

func _ready():
	lastDistance = $Path3D.curve.get_closest_offset(playerKart.body.global_position)

func _process(delta):
	time -= delta
	if get_tree().get_nodes_in_group("ai_kart").size() == 0:
		if time > 3:
			winTime = max(winTime, time)
			time = lerp(time, 3.0, delta * 4)
	
	$WinLose/TollBoothCheck/Bubble/Boss/Moustache.rotation = sin(time)
	
	if time < 0:
		if not raceEnded:
			$WinLose/Whistle.play()
			raceEnded = true
			$WinLose/Karts/SubViewport/Cam/ActualCamera.current = true
			$WinLose.process_mode = Node.PROCESS_MODE_INHERIT
			$WinLose/ColorRect.modulate = Color.TRANSPARENT
			$WinLose.show()
			$WinLose/Lose.modulate = Color.TRANSPARENT
			$WinLose/Win.modulate = Color.TRANSPARENT
			get_tree().create_tween().tween_property($WinLose/ColorRect, "modulate", Color(1, 1, 1, 0.8), 3)
			if get_tree().get_nodes_in_group("ai_kart").size() > 0:
				get_tree().create_tween().tween_property($WinLose/Lose, "modulate", Color(1, 1, 1, 1), 1).set_trans(Tween.TRANS_CIRC)
			else:
				won = true
				get_tree().create_tween().tween_property($WinLose/Win, "modulate", Color(1, 1, 1, 1), 1).set_trans(Tween.TRANS_CIRC)
		else:
			$WinLose/Karts/SubViewport/Cam.global_position = playerKart.vehicle.global_position + Vector3(2, 1, 2)
			$WinLose/Karts/SubViewport/Cam.look_at(playerKart.vehicle.global_position)
			$WinLose/EverythingElse/SubViewport/Cam.global_transform = $WinLose/Karts/SubViewport/Cam/ActualCamera.global_transform
	
	if floori(time * 2) % 2 == 0:
		$TrackUI/TimerContainer/Timer.text = "%2d:%02d" % [floor(time / 60), floori(time) % 60]
	else:
		$TrackUI/TimerContainer/Timer.text = "%2d %02d" % [floor(time / 60), floori(time) % 60]
	
	var udistance = $Path3D.curve.get_closest_offset(playerKart.body.global_position)
	var distanceoffset = udistance - lastDistance
	lastDistance = udistance
	distanceTraveled += clamp(distanceoffset, -1, 1)

func _on_static_body_3d_body_entered(body):
	var tween = get_tree().create_tween()
	body.global_position.y += 2
	body.velocity = Vector3.ZERO
	var bodydefaultcollision = body.collision_layer
	body.collision_layer = 0
	tween.tween_property(body, "global_position", $Path3D.curve.get_closest_point($Path3D.to_local(body.global_position)) + Vector3(0, 12, 0), 1).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(body, "collision_layer", bodydefaultcollision, 0)

func _on_continue_pressed():
	if not SettingsData.inStoryMode:
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	else:
		if not won:
			get_tree().reload_current_scene()
		else:
			SettingsData.currentMoney = 0
			get_tree().change_scene_to_packed(SettingsData.currentNextCutscene)
