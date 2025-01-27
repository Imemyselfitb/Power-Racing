extends Node3D

func _ready() -> void:
	$"Level Transition/ColorRect/AnimationPlayer".get_animation("transition out").loop_mode = Animation.LoopMode.LOOP_NONE
	$"Level Transition/ColorRect/AnimationPlayer".play("transition out")
	await $"Level Transition/ColorRect/AnimationPlayer".animation_finished
	#$"Level Transition".visible = false
