extends Node2D

const CONSUMIBLE_PEQUENO_SCENE = preload("res://consumiblePeque.tscn")
const CONSUMIBLE_GRANDE_SCENE = preload("res://consuGrande.tscn")

@onready var tilemap: TileMapLayer = $Bloques
@onready var consumibles_container: Node2D = $Consumibles
@onready var consumibles: TileMapLayer = $TileMapLayerObjetos

# En tu _ready()
func _ready():
	# Ya no llamas a colocar_consumibles() con posiciones fijas
	# En su lugar, llamas a esta nueva función
	spawn_objetos_desde_tilemap()

# Esta es la nueva función
func spawn_objetos_desde_tilemap():
	# Obtén la capa de "Objetos"
	# (Asegúrate de que $TileMapLayerObjetos sea el nombre correcto)
	
	# Obtenemos un array de todas las celdas que has pintado en esa capa
	var celdas_pintadas = consumibles.get_used_cells() # 0 es el ID de la capa de tileset

	for grid_pos in celdas_pintadas:
		# Opcional: revisa qué tile es usando los datos personalizados
		# (Aquí asumimos que cualquier cosa en esta capa es un consumible pequeño)
		
		# Llama a tu función original con la coordenada de la celda pintada
		colocar_objeto(CONSUMIBLE_PEQUENO_SCENE, grid_pos)
		
		# (Opcional) Borra el tile de "punto rojo" para que no se vea en el juego
		consumibles.set_cell(grid_pos, -1) # Borra el tile

func colocar_objeto(escena_para_instanciar, grid_pos):
	
	var mundo_pos = consumibles.map_to_local(grid_pos)
	
	var cell_size = consumibles.tile_set.tile_size
	mundo_pos += cell_size  /12.0
	
	var instancia = escena_para_instanciar.instantiate()
	
	consumibles_container.add_child(instancia)
	
	instancia.global_position = mundo_pos
