extends Node2D

const CONSUMIBLE_PEQUENO_SCENE = preload("res://consumiblePeque.tscn")
const CONSUMIBLE_GRANDE_SCENE = preload("res://consuGrande.tscn")
const CHARACTER = preload("res://character.tscn")
const DEATH_AREA = preload("res://deathArea.tscn")
const WIN_AREA = preload("res://win_area.tscn")

@onready var tilemap: TileMapLayer = $Bloques
@onready var consumibles_container: Node2D = $Consumibles
@onready var consumibles: TileMapLayer = $TileMapLayerObjetos
@onready var consumibleGrandes_container: Node2D = $ConsumiblesGrandes
@onready var consumiblesGrandes: TileMapLayer = $TileMapLayerObjetosGrandes
@onready var timer_muerte: Timer = $TimerMuerte
@onready var player: CharacterBody2D = $CharacterBody2D
var instanciaCharacter = CHARACTER.instantiate()
var deathArea = DEATH_AREA.instantiate()
var toDie:bool = false
var winArea = WIN_AREA.instantiate()
@onready var camera: Camera2D = $Camera2D
@onready var result_container: Node2D = $resultContainer
@onready var result_label: Label = $resultContainer/resultLabel
@onready var camara: Camera2D = $Camera2D

func _ready():
	self.add_child(instanciaCharacter)
	print("hola2")
	instanciaCharacter.global_position = Vector2(214,135)
	instanciaCharacter.global_scale = Vector2(0.5,0.5)
	instanciaCharacter.add_to_group("player")
	self.add_child(deathArea)
	deathArea.global_position = Vector2(110,445)
	deathArea.global_scale = Vector2(5,2.921)
	deathArea.add_to_group("spikes")
	self.add_child(winArea)
	winArea.global_position = Vector2(8,-360)
	winArea.global_scale = Vector2(1,1)
	winArea.add_to_group("win")
	spawn_objetos_desde_tilemap()
	GameManager.game_over.connect(_on_game_over)

func _on_game_over(hasWon:bool):
	# Esta función se ejecuta cuando GameManager emite la señal
	if hasWon:
		result_container.global_position = instanciaCharacter.global_position + Vector2(0,-100)
		result_label.text = "Has Ganado"
	else:
		result_container.global_position = instanciaCharacter.global_position + Vector2(0,-100)
		result_label.text = "Has Perdido"
		
	# (Aquí también puedes mostrar tu nodo "lol" que tenías en el GameManager)
	# @onready var lol: Node2D = $lol # (Si "lol" también está en esta escena)
	# lol.global_position = Vector2(100,100)
	
	
	# --- CORRECCIÓN 1 ---
	# Configura el timer como "one_shot" AQUÍ, una sola vez.
	timer_muerte.one_shot = true
		
func _process(delta: float) -> void:
	# --- CORRECCIÓN 2 ---
	# ¡No pongas "one_shot = false" aquí!
	
	# --- CORRECCIÓN 3 ---
	# Comprueba si la instancia es válida ANTES de acceder a ella.
	if is_instance_valid(instanciaCharacter):
		camara.global_position = instanciaCharacter.global_position
		# Si es válida, comprueba si está muriendo
		if instanciaCharacter.dying == true:
			# Si está muriendo Y el timer está parado, inícialo
			if timer_muerte.is_stopped():
				timer_muerte.start()
	# Si no es válida (is_instance_valid == false), significa que el personaje
	# ya se liberó (queue_free), pero el timer ya está corriendo.
	# Simplemente esperamos a que el timer termine.
			
# (Tu función spawn_objetos_desde_tilemap está bien)
func spawn_objetos_desde_tilemap():
	var celdas_pintadas = consumibles.get_used_cells()
	var celdas_pintadas_grande = consumiblesGrandes.get_used_cells() 

	for grid_pos in celdas_pintadas:
		colocar_objeto(CONSUMIBLE_PEQUENO_SCENE, grid_pos)
		consumibles.set_cell(grid_pos, -1) 
		
	for grid_pos in celdas_pintadas_grande:
		colocar_objeto(CONSUMIBLE_GRANDE_SCENE, grid_pos)
		consumiblesGrandes.set_cell(grid_pos, -1)

# (Tu función colocar_objeto está bien)
func colocar_objeto(escena_para_instanciar, grid_pos):
	var mundo_pos = consumibles.map_to_local(grid_pos)
	var cell_size = consumibles.tile_set.tile_size
	mundo_pos += cell_size / 12.0
	var instancia = escena_para_instanciar.instantiate()
	consumibles_container.add_child(instancia)
	instancia.global_position = mundo_pos


func _on_timer_muerte_timeout() -> void:
	print("hopla")

	GameManager.reiniciar_nivel()
	
