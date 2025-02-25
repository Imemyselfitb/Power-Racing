extends Node

var inStoryMode:bool = false
var currentNextLevel:PackedScene = load("res://scenes/levels/level1.tscn")
var currentNextCutscene:PackedScene = load("res://scenes/cutscenes/2.tscn")
var isController:bool = false

var currentTollBoothMinimum:int = 0
var currentMoney:int = 0

var callOnController:Callable

func _ready():
	Input.joy_connection_changed.connect(_check_joy)

func _check_joy(devince, connected):
	if Input.get_connected_joypads().size() > 0:
		isController = true
		if callOnController.is_valid():
			callOnController.call()
	else:
		isController = false

func _process(delta):
	if isController:
		if Input.is_action_just_pressed("ui_accept"):
			if get_viewport().gui_get_focus_owner():
				if not get_viewport().gui_get_focus_owner().disabled:
					get_viewport().gui_get_focus_owner().button_down.emit()
