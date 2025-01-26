extends Sprite3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween:Tween = get_tree().create_tween()
	var randomOffset = Vector2(randi_range(-256, 256), randi_range(-256, 256))
	tween.tween_interval(0.01)
	tween.tween_property($frame, "modulate", Color.BLACK, 0.01)
	tween.tween_interval(0.01)
	tween.tween_callback($frame.queue_free)
	tween.tween_property($punch, "offset", randomOffset, 0.5).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property($secondary, "offset", randomOffset * randf_range(0.8, 1.2), 0.6).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(self, "scale", Vector3(1.2, 1.2, 1.2), 1).set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(self, "modulate", Color.TRANSPARENT, 1).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(queue_free)
	texture = load("res://assets/sprite/punchbg" + str(randi_range(1, 3)) + ".png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
