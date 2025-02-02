extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Front.get_surface_override_material(0).albedo_color = Color(randf(), randf(), randf())
	$Back.get_surface_override_material(0).albedo_color = Color(randf(), randf(), randf())
