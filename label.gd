extends Label

var texto:String

func _process(delta: float) -> void:
	texto = str(GameManager.getScore())
	if text != texto:
		text = texto
