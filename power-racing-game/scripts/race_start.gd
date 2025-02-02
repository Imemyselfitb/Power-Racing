extends Control

func _ready():
	process_mode = ProcessMode.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true
	BgMusic._play_another_song(load("res://assets/music/The seas.mp3"))
	$origin/Rotate/Label.text = ""

var checkInput = false

func _process(delta):
	if checkInput:
		if Input.is_anything_pressed():
			$origin/Rotate/AnimationPlayer.play("321")
			$Finish.start()
			checkInput = false

func _on_input_delay_timeout():
	checkInput = true
	$origin/Rotate/Label.text = "Press Any Button\nTo Start"

func _on_finish_timeout():
	process_mode = ProcessMode.PROCESS_MODE_INHERIT
	get_tree().paused = false

func _on_animation_player_animation_finished(anim_name):
	queue_free()
