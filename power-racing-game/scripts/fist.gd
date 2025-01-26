extends Node3D

func _process(delta: float) -> void:
	var mouse: Vector2 = get_viewport().get_mouse_position()
	var size: Vector2 = get_viewport().get_visible_rect().size
	var camera: Camera3D = get_tree().root.get_camera_3d()
	$Sprite3D.position.x = (2 * mouse.x - size.x) / size.x * 5
	$Sprite3D.position.y = 0
	$Sprite3D.position.z = 0
	
	$Area3D.position = $Sprite3D.position
	
	$Sprite3D.scale.x = abs($Sprite3D.position.x) / 4 + 0.5
	$Sprite3D.scale.y = abs($Sprite3D.position.x) / 4 + 0.5
	$Sprite3D.flip_h = ($Sprite3D.position.x > 0)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			$Sprite3D.position.x *= 1.3
			var bodies: Array[Node3D] = $Area3D.get_overlapping_bodies()
			for body in bodies:
				if body.name == "Vehicle" and body.get_parent().name != "PlayerKart":
					var kart: KartAI = body.get_parent()
					kart.hits -= 1
					if kart.hits < 0:
						kart.lives -= 1
						kart.hits = kart.lives
						if kart.lives < 1:
							kart.get_parent().remove_child(kart)
					#print("OUCH! ", kart, ": ", kart.hits, kart.lives)
