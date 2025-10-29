extends Node

# Aquí se guarda la puntuación
var score: int = 0


# Esta señal es para que tu UI (interfaz) pueda escuchar
# los cambios de puntuación y actualizarse.
signal score_updated(new_score)

# Esta es la función clave.
# Los consumibles llamarán a ESTA función.
func on_consumable_collected(consumable_node):
	
	# 1. Sumamos los puntos
	if consumable_node.is_in_group("consumiblePeque"):
		score += 1
	if consumable_node.is_in_group("consumibleGrande"):
		score += 5
	print("Puntuación actual: ", score)

	# 2. Emitimos la señal para que la UI se actualice
	score_updated.emit(score)

	consumable_node.play("consumed")
	consumable_node.animation_finished.connect(eliminar.bind(consumable_node))

func eliminar(consumable) ->void:
	consumable.queue_free()
