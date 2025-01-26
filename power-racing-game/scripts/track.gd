extends Node3D

func _process(delta):
	pass

func _on_static_body_3d_body_entered(body):
	if body is Kart:
		pass #play respawn visual idk
	
	var tween = get_tree().create_tween()
	body.global_position.y += 2
	body.velocity = Vector3.ZERO
	body.process_mode = ProcessMode.PROCESS_MODE_DISABLED
	tween.tween_property(body, "global_position", $Path3D.curve.get_closest_point($Path3D.to_local(body.global_position)) + Vector3(0, 12, 0), 1).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(body, "process_mode", ProcessMode.PROCESS_MODE_INHERIT, 0.1)
