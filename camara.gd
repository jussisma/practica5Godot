extends Camera2D

@onready var character_body_2d_2: CharacterBody2D = $"../CharacterBody2D2"

func _process(delta: float) -> void:
	if character_body_2d_2 != null:
		global_position.y = character_body_2d_2.global_position.y
