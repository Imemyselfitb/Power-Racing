extends Node3D
class_name Cutscene

@export var scenes:Array[MiniScene] = []

var currentSceneidx:int = 0

func _ready():
	$UI/TextPanel/Text.text = scenes[currentSceneidx].text
	$UI/TextPanel/Text.visible_characters = 0
	$Look.look_at(get_node(scenes[currentSceneidx].focusNode).global_position)
	$TextPlayer.position = get_node(scenes[currentSceneidx].focusNode).global_position
	
	SettingsData.currentNextCutscene = nextcutscene
	SettingsData.currentTollBoothMinimum = tollboothcharge
	SettingsData.currentMoney = 0
	BgMusic._play_another_song(load("res://assets/music/Wild Cherry Village 4.mp3"))

var progress = 0

@export var nextLevel:PackedScene = null
@export var nextcutscene:PackedScene = null
@export var tollboothcharge:float = 0

var finished = false

func _process(delta):
	progress += scenes[currentSceneidx].speed * delta
	$UI/TextPanel/Text.visible_characters = progress
	$Camera3D.rotation = lerp($Camera3D.rotation, $Look.rotation, 12 * delta)
	if Input.is_action_just_pressed("punch"):
		if currentSceneidx < scenes.size() - 1:
			currentSceneidx += 1
			$UI/TextPanel/Text.text = scenes[currentSceneidx].text
			progress = 0
			$Look.look_at(get_node(scenes[currentSceneidx].focusNode).global_position)
			$TextPlayer.position = get_node(scenes[currentSceneidx].focusNode).global_position
			$TextPlayer.stream = scenes[currentSceneidx].textsound
			$TextPlayer.play()
		else:
			$"UI/Level Transition/ColorRect/AnimationPlayer".connect("animation_finished", gotolevel)
			$"UI/Level Transition/ColorRect/AnimationPlayer".play("transition in")

func gotolevel(animname:String):
	get_tree().change_scene_to_packed(nextLevel)
