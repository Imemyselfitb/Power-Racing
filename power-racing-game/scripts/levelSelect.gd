extends Control

var current_selected: Vector2 = Vector2(0, 0)

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

func toggleUI(advanceUI: Callable):
	var prevIdx = 1 + current_selected.x + current_selected.y * 4
	$Levels.get_node("Level" + str(prevIdx)).mouse_exited.emit()
	advanceUI.call()
	var curIdx = 1 + current_selected.x + current_selected.y * 4
	$Levels.get_node("Level" + str(curIdx)).mouse_entered.emit()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		toggleUI(func select(): current_selected.x = clamp(current_selected.x + 1, 0, 3))
	elif Input.is_action_just_pressed("ui_left"):
		toggleUI(func select(): current_selected.x = clamp(current_selected.x - 1, 0, 3))
	if Input.is_action_just_pressed("ui_up"):
		toggleUI(func select(): current_selected.y = clamp(current_selected.y - 1, 0, 1))
	elif Input.is_action_just_pressed("ui_down"):
		toggleUI(func select(): current_selected.y = clamp(current_selected.y + 1, 0, 1))
	if Input.is_action_just_pressed("ui_accept"):
		var curIdx = 1 + current_selected.x + current_selected.y * 4
		$Levels.get_node("Level" + str(curIdx)).button_down.emit()
	
