extends Node3D

var step: int = 0
var finished: bool = false
var lastWasController: bool = false

@export var player: Kart = null
@onready var aiFrozen: Node3D = $DummyKart
@onready var aiMoving: Node3D = $KartMoving
@onready var aiMovingInitialStats: Dictionary = {
	"pos": $KartMoving.body.global_position,
	"dir": $KartMoving.vehicle.rotation
}

func _ready() -> void:
	BgMusic._play_another_song(load("res://assets/music/Waiting Room.mp3"))

func _physics_process(delta: float) -> void:
	if step <= 4:
		if is_instance_valid(aiMoving):
			aiMoving.global_position = aiMovingInitialStats["pos"]
			aiMoving.body.global_position = aiMovingInitialStats["pos"]
			aiMoving.body.rotation = aiMovingInitialStats["dir"]
			aiMoving.vehicle.global_position = aiMovingInitialStats["pos"]
			aiMoving.vehicle.rotation = aiMovingInitialStats["dir"]
			aiMoving.vehicle.velocity = Vector3.ZERO

func checkAdvanceController() -> void:
	match step:
		0:
			if Input.is_action_just_pressed("MoveForward"):
				$Control/Label.text = "Left Trigger"
				step += 1
		1:
			if Input.is_action_just_pressed("MoveBackward"):
				$Control/Label.text = "Left Joystick"
				step += 1
		2:
			if Input.is_action_pressed("TurnLeft") or Input.is_action_pressed("TurnRight"):
				if player.vehicle.velocity.length() > 0.5:
					$Control/Label.text = "Approach the other kart"
					$Control/Label.position -= 30
					step += 1
		3:
			if (player.body.global_position - aiFrozen.body.global_position).length() < 2:
				$Control/Label.text = ""
				$Control/Label.position += 30
				$Control/PunchIndicatorController.show()
				step += 1
		4:
			if not is_instance_valid(aiFrozen):
				$KartMoving.visible = true
				$Control/Label.text = "Now punch this Moving kart!"
				$Control/PunchIndicatorMouse.hide()
				step += 1
		5:
			if not is_instance_valid(aiMoving):
				$Control/Label.text = "Well Learned!"
				finished = true
				$FinishTimer.start()

func checkAdvanceKeyboard() -> void:
	match step:
		0:
			if Input.is_action_pressed("MoveForward"):
				$Control/Label.text = "S - Move Backwards"
				step += 1
		1:
			if Input.is_action_pressed("MoveBackward"):
				$Control/Label.text = "A/D - Turning"
				step += 1
		2:
			if Input.is_action_pressed("TurnLeft") or Input.is_action_pressed("TurnRight"):
				if player.vehicle.velocity.length() > 0.5:
					$Control/Label.text = "Approach the other kart"
					$Control/Label.position.x -= 30
					step += 1
		3:
			if (player.body.global_position - aiFrozen.body.global_position).length() < 2:
				$Control/Label.text = "/ SPACE - Punch"
				$Control/Label.position.x += 30
				$Control/PunchIndicatorMouse.show()
				step += 1
		4:
			if not is_instance_valid(aiFrozen):
				$Control/Label.text = "Now punch this Moving kart!"
				$KartMoving.visible = true
				$Control/PunchIndicatorMouse.hide()
				step += 1
		5:
			if not is_instance_valid(aiMoving):
				$Control/Label.text = "Well Learned!"
				finished = true
				$FinishTimer.start()

func _process(delta) -> void:
	if finished:
		return
	
	if SettingsData.isController != lastWasController:
		step = 0
		lastWasController = SettingsData.isController
		$Control/Label.show()
		$Control/PunchIndicatorController.hide()
		$Control/PunchIndicatorMouse.hide()
	
	if SettingsData.isController:
		checkAdvanceController()
		if step == 0:
			$Control/Label.text = "Right Trigger"
	else:
		checkAdvanceKeyboard()
		if step == 0:
			$Control/Label.text = "W - Forwards"

func _on_finish_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
