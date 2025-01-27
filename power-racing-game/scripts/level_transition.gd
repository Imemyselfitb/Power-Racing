extends Node

func ChangeScene(thisNode: Node, new_scene_path: String):
	var transition: CanvasLayer = preload("res://scenes/levelTransition.tscn").instantiate()
	thisNode.add_child(transition)
	
	var anim: AnimationPlayer = transition.get_node("ColorRect/AnimationPlayer")
	anim.play("transition in")
	print("PLEASE PLAY")
	#get_tree().change_scene_to_file(new_scene_path)
	
	transition.queue_free()
