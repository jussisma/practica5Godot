extends Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

	

func _process(delta: float) -> void:
	sprite.play("default")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.displayResult(true)
		timer.start()


func _on_timer_timeout() -> void:
	GameManager.reiniciar_nivel()
