extends Area2D

func _process(delta: float) -> void:
	global_position = global_position.lerp(Vector2(110,-118),0.05*delta)
