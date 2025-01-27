extends Control

func clicked(level_name: String):
	$"Level Transition".visible = true
	$"Level Transition/ColorRect/AnimationPlayer".get_animation("transition in").loop_mode = Animation.LoopMode.LOOP_NONE
	$"Level Transition/ColorRect/AnimationPlayer".play("transition in")
	await $"Level Transition/ColorRect/AnimationPlayer".animation_finished
	get_tree().change_scene_to_file("res://scenes/levels/" + level_name.to_lower() + ".tscn")

func hover_start(button: TextureButton):
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(button, "modulate:a", 0.7, 0.2).set_trans(Tween.TRANS_SINE)

func hover_end(button: TextureButton):
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(button, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_SINE)

func _ready() -> void:
	for LEVEL: TextureButton in $Levels.get_children():
		LEVEL.button_down.connect(clicked.bind(LEVEL.name))
		LEVEL.mouse_entered.connect(hover_start.bind(LEVEL))
		LEVEL.mouse_exited.connect(hover_end.bind(LEVEL))
