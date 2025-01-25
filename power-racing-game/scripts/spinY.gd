@tool
extends Node3D
@export var amount:float = 2

func _process(delta):
	rotation.y += delta * amount
