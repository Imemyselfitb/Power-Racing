extends Node3D

var time:float = 180 # 3 mins

func _process(delta):
	time -= delta
	if floori(time * 2) % 2 == 0:
		$TrackUI/TimerContainer/Timer.text = "%2d:%02d" % [floor(time / 60), floori(time) % 60]
	else:
		$TrackUI/TimerContainer/Timer.text = "%2d %02d" % [floor(time / 60), floori(time) % 60]

func _on_static_body_3d_body_entered(body):
	if body is Kart:
		pass #play respawn visual idk
	
	var tween = get_tree().create_tween()
	body.global_position.y += 2
	body.velocity = Vector3.ZERO
	body.process_mode = ProcessMode.PROCESS_MODE_DISABLED
	tween.tween_property(body, "global_position", $Path3D.curve.get_closest_point($Path3D.to_local(body.global_position)) + Vector3(0, 12, 0), 1).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(body, "process_mode", ProcessMode.PROCESS_MODE_INHERIT, 0.1)
