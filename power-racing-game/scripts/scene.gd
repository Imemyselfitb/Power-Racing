extends Resource
class_name MiniScene

@export var focusNode:NodePath = ""
@export_multiline var text:String = ""
@export var textsound:AudioStream = null
## characters per second
@export var speed:float = 10
@export var forceSkipAtCharacters:int = 9999999
