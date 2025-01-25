@tool
extends Sprite3D

func _process(delta):
	look_at(get_viewport().get_camera_3d().global_position)
	rotation.x = 0
	rotation.z = 0
