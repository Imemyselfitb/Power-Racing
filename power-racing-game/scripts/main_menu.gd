extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	for member in $UI/SlideInButtons.get_children():
		member.position.x = -500
		tween.tween_property(member, "position:x", $UI/SlideInButtons.size.x / 4.0 - (member.size.x / 2.0), 1.3).set_trans(Tween.TRANS_EXPO)
		tween.parallel().tween_interval(0.2)
