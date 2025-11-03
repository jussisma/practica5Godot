extends Camera2D

@onready var character_body_2d_2: CharacterBody2D = $"../CharacterBody2D2"
var parent = self.get_parent()
var character
@onready var node_2d: Node2D = $".."
func _process(delta: float) -> void:
	for child in node_2d.get_children():
		if child is CharacterBody2D:
			character = child
	self.global_position = character.global_position
