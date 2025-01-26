extends Control

func clicked(level_name: String):
	get_tree().change_scene_to_file("res://scenes/levels/" + level_name.to_lower() + ".tscn")

func _ready() -> void:
	for LEVEL: TextureButton in $Levels.get_children():
		LEVEL.button_down.connect(clicked.bind(LEVEL.name))
