@tool
extends Node3D
@export var x:float = 1
@export var y:float = 1
@export var z:float = 1
func _process(delta):
	rotation.x += x*delta
	rotation.y += y*delta
	rotation.z += z*delta
