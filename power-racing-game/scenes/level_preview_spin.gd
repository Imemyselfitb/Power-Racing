extends Node3D

func _process(delta):
	rotation.y += delta * 0.5;
	if Input.is_anything_pressed():
		queue_free()
