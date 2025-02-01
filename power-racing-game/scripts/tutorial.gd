extends Node3D

var step:int = 0
var lastWasController:bool = false
@export var ai:Node3D = null
@export var player:Kart = null

var finished = false

func _ready():
	BgMusic._play_another_song(load("res://assets/music/Waiting Room.mp3"))

func _process(delta):
	if finished:
		return
	
	if not is_instance_valid(ai):
		finished = true
		$FinishTimer.start()
	
	if SettingsData.isController != lastWasController:
		step = 0
		lastWasController = SettingsData.isController
		$Control/Label.show()
		$Control/PunchIndicatorController.hide()
		$Control/PunchIndicatorMouse.hide()
		if SettingsData.isController:
			$Control/Label.text = "Right Trigger"
		else:
			$Control/Label.text = "W"
	if SettingsData.isController:
		if step == 0:
			if Input.is_action_just_pressed("MoveForward"):
				$Control/Label.text = "Left Trigger"
				step += 1
		elif step == 1:
			if Input.is_action_just_pressed("MoveBackward"):
				$Control/Label.text = "Left Joystick"
				step += 1
		elif step == 2:
			if Input.is_action_just_pressed("TurnLeft") or Input.is_action_just_pressed("TurnRight"):
				step += 1
				$Control/Label.text = "Approach the other kart"
		elif step == 3:
			if (player.body.global_position - ai.body.global_position).length() < 2:
				$Control/Label.hide()
				$Control/PunchIndicatorController.show()
				step += 1
	else:
		if step == 0:
			if Input.is_action_just_pressed("MoveForward"):
				$Control/Label.text = "S"
				step += 1
		elif step == 1:
			if Input.is_action_just_pressed("MoveBackward"):
				$Control/Label.text = "A/D"
				step += 1
		elif step == 2:
			if Input.is_action_just_pressed("TurnLeft") or Input.is_action_just_pressed("TurnRight"):
				step += 1
				$Control/Label.text = "Approach the other kart"
		elif step == 3:
			if (player.body.global_position - ai.body.global_position).length() < 2:
				$Control/Label.hide()
				$Control/PunchIndicatorMouse.show()
				step += 1

func _on_finish_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
