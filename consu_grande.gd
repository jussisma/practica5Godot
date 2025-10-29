extends AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	
	GameManager.on_consumable_collected(self)

	area_2d.monitoring = false
