extends Node

@onready var levelSelect: Control = $UI/LevelSelect

var inLevelSelect:bool = true

var mouseOnStory:bool = true

func _controller():
	if inLevelSelect:
		$UI/SlideInButtons/StoryButton.grab_focus()
		print("fuck")
	else:
		$UI/LevelSelect/Levels/Level1.grab_focus()

# Called when the node enters the scene tree for the first time.
func _ready():
	SettingsData.callOnController = _controller
	if $"/root/SettingsData".isController:
		_controller()
	levelSelect.position.x = -get_viewport().size.x
	var c = 0
	for member in $UI/SlideInButtons.get_children():
		c += 1
		member.position.x = -500
		var tween = get_tree().create_tween()
		tween.tween_property(member, "position:x", $UI/SlideInButtons.size.x / 8.0 - (member.size.x / 2.0), 1.3 +(c * 0.1)).set_trans(Tween.TRANS_EXPO)

func _on_level_select_button_button_down() -> void:
	inLevelSelect = false
	levelSelect.visible = true
	var tween: Tween = get_tree().create_tween()
	for member: Button in $UI/SlideInButtons.get_children():
		member.disabled = true
		tween.tween_property(member, "position:x", -500, 0.5).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(levelSelect, "position", Vector2(0,0), 1.5).set_trans(Tween.TRANS_ELASTIC)

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
