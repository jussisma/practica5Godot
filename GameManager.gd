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
	game_over.emit(hasWon)

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

signal score_updated(new_score)

func on_consumable_collected(consumable_node):
	var sprite = consumable_node.get_node("AnimatedSprite2D")
	
	if consumable_node.is_in_group("consumiblePeque"):
		score += 1
	if consumable_node.is_in_group("consumibleGrande"):
		score += 5

	score_updated.emit(score)

	sprite.play("consumed")
	sprite.animation_finished.connect(eliminar.bind(consumable_node))

func eliminar(consumable) ->void:
	consumable.queue_free()
	
