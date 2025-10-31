extends Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(body: Node2D) -> void:

	if body.is_in_group("player"):
		GameManager.on_consumable_collected(self)
		self.monitoring = false
