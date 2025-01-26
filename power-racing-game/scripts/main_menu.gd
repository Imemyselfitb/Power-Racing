extends Node

@onready var levelSelect: Control = $UI/LevelSelect

# Called when the node enters the scene tree for the first time.
func _ready():
	levelSelect.position.x = -get_viewport().size.x
	var tween = get_tree().create_tween()
	for member in $UI/SlideInButtons.get_children():
		member.position.x = -500
		tween.tween_property(member, "position:x", $UI/SlideInButtons.size.x / 4.0 - (member.size.x / 2.0), 1.3).set_trans(Tween.TRANS_EXPO)
		tween.parallel().tween_interval(0.2)


func _on_level_select_button_button_down() -> void:
	levelSelect.visible = true
	var tween: Tween = get_tree().create_tween()
	for member: Button in $UI/SlideInButtons.get_children():
		member.disabled = true
		tween.tween_property(member, "position:x", -500, 0.5).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(levelSelect, "position", Vector2(0,0), 1.5).set_trans(Tween.TRANS_ELASTIC)
	
