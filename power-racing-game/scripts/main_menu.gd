extends Node

@onready var levelSelect: Control = $UI/LevelSelect

var notInLevelSelect:bool = true

var mouseOnStory:bool = true

func _controller():
	if notInLevelSelect:
		$UI/SlideInButtons/StoryButton.grab_focus()
	else:
		$UI/LevelSelect/Back.grab_focus()

# Called when the node enters the scene tree for the first time.
func _ready():
	BgMusic._play_another_song(load("res://assets/music/Wild Cherry Village 4.mp3"))
	SettingsData.callOnController = _controller
	if $"/root/SettingsData".isController:
		_controller()
	
	levelSelect.connect("closeLevelSelect", _on_level_select_closed)
	levelSelect.position.x = -get_viewport().size.x
	var i: int = 0
	for member in $UI/SlideInButtons.get_children():
		i += 1
		member.position.x = -500
		var tween: Tween = get_tree().create_tween()
		var newX: float = $UI/SlideInButtons.size.x / 10.0 - (member.size.x / 2.0)
		tween.tween_property(member, "position:x", newX, 1.3 + (i * 0.1)).set_trans(Tween.TRANS_EXPO)

func _on_level_select_button_button_down() -> void:
	BgMusic._play_another_song(load("res://assets/music/Waiting Room.mp3"))
	
	notInLevelSelect = false
	levelSelect.visible = true
	levelSelect.position.x = -get_viewport().size.x
	$UI/SlideInButtons.hide()
	var tween: Tween = get_tree().create_tween()
	for member: Button in $UI/SlideInButtons.get_children():
		member.disabled = true
		tween.tween_property(member, "position:x", -500, 0.5).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(levelSelect, "position:x", 0, 1.5).set_trans(Tween.TRANS_ELASTIC)
	await tween.tween_interval(0.1)
	
	if SettingsData.isController:
		$UI/LevelSelect/Back.grab_focus()
	print("forwarfd")

func _on_level_select_closed() -> void:
	BgMusic._play_another_song(load("res://assets/music/Wild Cherry Village 4.mp3"))
	$UI/SlideInButtons.visible = true
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(levelSelect, "position:x", -get_viewport().size.x, 0.8).set_trans(Tween.TRANS_EXPO)
	tween.tween_callback(func setVisibility(): levelSelect.visible = false; notInLevelSelect = true)
	
	levelSelect.visible = false
	var i: int = 0
	for member: Button in $UI/SlideInButtons.get_children():
		i += 1
		member.disabled = false
		var newX: float = $UI/SlideInButtons.size.x / 10.0 - (member.size.x / 2.0)
		tween.tween_property(member, "position:x", newX, 0.5 + (i * 0.1)).set_trans(Tween.TRANS_EXPO)
	await tween.tween_interval(5)
	if SettingsData.isController:
		pass#$UI/SlideInButtons/StoryButton.grab_focus()

func _on_story_button_pressed():
	$"UI/Level Transition/ColorRect/AnimationPlayer".play("transition in")
	$"UI/Level Transition/ColorRect/AnimationPlayer".connect("animation_finished", _go_to_first_cutscene)
	$UI.grab_click_focus()
	for member: Button in $UI/SlideInButtons.get_children():
		member.disabled = true
	SettingsData.inStoryMode = true
	SettingsData.currentNextLevel = preload("res://scenes/levels/level1.tscn")

func _go_to_first_cutscene(anim_name:String):
	get_tree().change_scene_to_file("res://scenes/cutscenes/1.tscn")

func _on_tutorial_button_button_down():
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
