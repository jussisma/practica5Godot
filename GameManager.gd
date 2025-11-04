extends Node
@onready var label: Label = $CanvasLayer/Label
const SONIDO_MUERTE = preload("res://Sound/Hurt.wav")
const SONIDO_MOVIMIENTO = preload("res://Sound/Jump.wav")
const SONIDO_CONSUMIBLE = preload("res://Sound/pickupCoin.wav")
const MUSICA = preload("res://Sound/Music.wav")
const WIN = preload("res://Sound/win.mp3")
@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer
@onready var sfx_player_movement: AudioStreamPlayer2D = $SFXPlayerMovement
@onready var sfx_player_music: AudioStreamPlayer2D = $SFXPlayerMusic
@onready var node_2d: Node2D = $Node2D
@onready var sfx_player_win: AudioStreamPlayer2D = $SFXPlayerWIn

signal game_over(hasWon)

func displayResult(hasWon:bool):
	# En lugar de tocar el Label, emite la señal
	# y envía el resultado (victoria o derrota).
	game_over.emit(hasWon)

# Aquí se guarda la puntuación
var score: int = 0

func _ready() -> void:
	sfx_player_music.stream = MUSICA
	sfx_player_music.play()

func play_sfx(nombre):
	if nombre == "muerte":
		sfx_player.stream = SONIDO_MUERTE
	if nombre == "movimiento":
		sfx_player_movement.stream = SONIDO_MOVIMIENTO
	if nombre == "consumible":
		sfx_player.stream = SONIDO_CONSUMIBLE
	sfx_player.play()
	sfx_player_movement.play()
	sfx_player_win.play()
	
	

func reiniciar_nivel():
	score = 0
	var error = get_tree().reload_current_scene()
	
	if error != OK:
		print("error")
	

func getScore() -> int:
	return score

# Esta señal es para que tu UI (interfaz) pueda escuchar
# los cambios de puntuación y actualizarse.
signal score_updated(new_score)

# Esta es la función clave.
# Los consumibles llamarán a ESTA función.
func on_consumable_collected(consumable_node):
	var sprite = consumable_node.get_node("AnimatedSprite2D")
	
	# 1. Sumamos los puntos
	if consumable_node.is_in_group("consumiblePeque"):
		score += 1
	if consumable_node.is_in_group("consumibleGrande"):
		score += 5
	print("Puntuación actual: ", score)

	# 2. Emitimos la señal para que la UI se actualice
	score_updated.emit(score)

	sprite.play("consumed")
	sprite.animation_finished.connect(eliminar.bind(consumable_node))

func eliminar(consumable) ->void:
	consumable.queue_free()
	
# Nivel1.gd

# 1. Carga las escenas que quieres instanciar
