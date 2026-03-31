extends TileMapLayer

var moisture: FastNoiseLite = FastNoiseLite.new()
var temperature: FastNoiseLite = FastNoiseLite.new()
var altitude: FastNoiseLite = FastNoiseLite.new()

const CHUNK_SIZE: int = 256
const TILE_SIZE: int = 32
const CHUNK_LOAD_THRESHOLD: int = 2000
const WATER_THRESHOLD: float = -0.5

const SOURCE_GRASS: int = 0
const SOURCE_WATER: int = 1
var grass_tiles: Array[Vector2i] = []
var water_tiles: Array[Vector2i] = []

@onready var player: Player = GameManager.player

var generated_chunks: Dictionary[Variant, Variant] = {}
var chunk_queue: Array[Variant] = []

func _ready() -> void:
	if tile_set:
		var source_grass: TileSetAtlasSource = tile_set.get_source(SOURCE_GRASS)
		if source_grass:
			for i in range(source_grass.get_tiles_count()):
				grass_tiles.append(source_grass.get_tile_id(i))
				
		var source_water: TileSetAtlasSource = tile_set.get_source(SOURCE_WATER)
		if source_water:
			for i in range(source_water.get_tiles_count()):
				water_tiles.append(source_water.get_tile_id(i))
	
	initialise_noise()
	generate_chunk(Vector2i(0, 0))

func _physics_process(delta: float) -> void:
	check_chunk_loading() # Check if we need a new chunk
	process_chunk_queue() # Process chunks gradually
	
func initialise_noise() -> void:
	moisture.seed = randi()
	temperature.seed = randi()
	
	altitude.seed = randi()
	altitude.frequency = 0.05
	altitude.fractal_type = FastNoiseLite.FRACTAL_FBM
	altitude.fractal_octaves = 2
	
func generate_chunk(chunk_position: Vector2i) -> void:
	if chunk_position in generated_chunks:
		return
	generated_chunks[chunk_position] = true
	chunk_queue.append(chunk_position)
	
func process_chunk_queue() -> void:

	if chunk_queue.is_empty():
		return
	
	var chunk_position: Vector2i = chunk_queue.pop_front()
	var chunk_offset: Vector2i = chunk_position * CHUNK_SIZE
	
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			var world_x = chunk_offset.x + x
			var world_y = chunk_offset.y + y
			
			var altitude_value: float = altitude.get_noise_2d(world_x, world_y)
			
			var source_id: int
			var atlas_coord: Vector2i
			
			if altitude_value < WATER_THRESHOLD:
				source_id = SOURCE_WATER
				atlas_coord = water_tiles[randi() % water_tiles.size()] if not water_tiles.is_empty() else Vector2i(0, 0)
			else:
				source_id = SOURCE_GRASS
				atlas_coord = grass_tiles[randi() % grass_tiles.size()] if not grass_tiles.is_empty() else Vector2i(0, 0)
			
			set_cell(Vector2i(world_x, world_y), source_id, atlas_coord, 0)
	
func check_chunk_loading() -> void:
	if not is_instance_valid(player):
		player = GameManager.player
		if not is_instance_valid(player):
			return
	
	var player_chunk: Vector2i = Vector2i(
		floor(player.global_position.x / (CHUNK_SIZE * TILE_SIZE)),
		floor(player.global_position.y / (CHUNK_SIZE * TILE_SIZE))
	)
	
	var local_x: int = posmod(player.global_position.x, CHUNK_SIZE * TILE_SIZE)
	var local_y: int = posmod(player.global_position.y, CHUNK_SIZE * TILE_SIZE)
	
	if local_x < CHUNK_LOAD_THRESHOLD:
		generate_chunk(player_chunk + Vector2i(-1, 0)) # Left
	elif local_x > (CHUNK_SIZE * TILE_SIZE - CHUNK_LOAD_THRESHOLD):
		generate_chunk(player_chunk + Vector2i(1, 0)) # Right
		
	if local_y < CHUNK_LOAD_THRESHOLD:
		generate_chunk(player_chunk + Vector2i(0, -1)) # Up
	elif local_y > (CHUNK_SIZE * TILE_SIZE - CHUNK_LOAD_THRESHOLD):
		generate_chunk(player_chunk + Vector2i(0, 1)) # Down
