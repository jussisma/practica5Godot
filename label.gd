extends Label

var texto:String

func _process(delta: float) -> void:
	texto = str(GameManager.getScore())
	if text != texto:
		text = texto


func _on_timer_muerte_timeout() -> void:
	pass # Replace with function body.
