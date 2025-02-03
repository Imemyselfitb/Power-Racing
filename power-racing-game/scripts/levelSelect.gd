extends Control

signal closeLevelSelect

var current_selected: Vector2 = Vector2(0, 0)

var allowClicks = true
func clickedLevel(level_name: String):
	if allowClicks:
		allowClicks = false
		$"Level Transition".visible = true
		$"Level Transition/ColorRect/AnimationPlayer".get_animation("transition in").loop_mode = Animation.LoopMode.LOOP_NONE
		$"Level Transition/ColorRect/AnimationPlayer".play("transition in")
		await $"Level Transition/ColorRect/AnimationPlayer".animation_finished
		
		match level_name:
			"grass":
				get_tree().change_scene_to_file("res://scenes/levels/level1.tscn")
			"mountain":
				get_tree().change_scene_to_file("res://scenes/levels/mountain.tscn")
			"Level3":
				get_tree().change_scene_to_file("res://scenes/levels/loop.tscn")
			"Level4":
				get_tree().change_scene_to_file("res://scenes/levels/river.tscn")
		#get_tree().change_scene_to_file("res://scenes/levels/" + level_name.to_lower() + ".tscn")

func hover_start(button: TextureButton):
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(button, "modulate:a", 0.7, 0.2).set_trans(Tween.TRANS_SINE)

func hover_end(button: TextureButton):
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(button, "modulate:a", 1.0, 0.2).set_trans(Tween.TRANS_SINE)

func _ready() -> void:
	for LEVEL: Button in $Levels.get_children():
		LEVEL.button_down.connect(clickedLevel.bind(LEVEL.name))
		LEVEL.mouse_entered.connect(hover_start.bind(LEVEL))
		LEVEL.mouse_exited.connect(hover_end.bind(LEVEL))
		LEVEL.focus_entered.connect(hover_start.bind(LEVEL))
		LEVEL.focus_exited.connect(hover_end.bind(LEVEL))

func toggleUI(advanceUI: Callable):
	var prevIdx = 1 + current_selected.x + current_selected.y * 4
	$Levels.get_node("Level" + str(prevIdx)).mouse_exited.emit()
	advanceUI.call()
	var curIdx = 1 + current_selected.x + current_selected.y * 4
	$Levels.get_node("Level" + str(curIdx)).mouse_entered.emit()

func back_to_main_screen() -> void:
	closeLevelSelect.emit()
