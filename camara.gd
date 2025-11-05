extends Camera2D

@export var target_character: Node2D 

func _ready() -> void:
	if target_character:
		self.target_node_path = target_character.get_path()

	self.drag_vertical_enabled = true
	
	self.drag_horizontal_enabled = false
	
	self.drag_top_margin = 0.3
	self.drag_bottom_margin = 0.5

func _process(delta: float) -> void:
	self.global_position.x = 91
