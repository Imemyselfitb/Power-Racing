extends Node3D

@export var flinch:float = 1

@export var path:Path3D = null
var pathfollow: PathFollow3D = PathFollow3D.new()

@onready var vehicle:Node3D = $Vehicle
@onready var body:Node3D = $Body

@export var speed:float = 172
@export var turnspeed:float = 30

var gravity = 9

var health:int = 3
