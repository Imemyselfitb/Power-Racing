extends AnimatedSprite3D

func _ready():
	play("default")

func _process(delta):
	$Sprite3D.position.y += delta * 0.5

func _on_timer_timeout():
	queue_free()
