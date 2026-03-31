extends TileMapLayer

const CHUNK_SIZE: int = 256
const TILE_SIZE: int = 32
const CHUNK_LOAD_THRESHOLD: int = 2000

const SOURCE_REGULAR_GRASS: int = 0
const SOURCE_FLOWER_GRASS: int = 1
const SOURCE_STONE_SLABS: int = 2

var regular_grass_tiles: Array[Vector2i] = []
var flower_grass_tiles: Array[Vector2i] = []
var stone_path_tiles: Array[Vector2i] = []

# Noise for blob generation (Stone Paths)
var path_noise: FastNoiseLite = FastNoiseLite.new()
const PATH_THRESHOLD: float = 0.4 # Adjust this for path rarity (higher = rarer)

@onready var player: Player = GameManager.player

var generated_chunks: Dictionary[Variant, Variant] = {}
var chunk_queue: Array[Variant] = []

func _ready() -> void:
	# Initialize noise for paths
	path_noise.seed = randi()
	path_noise.frequency = 0.03 # Low frequency creates larger, smoother blobs
	
	if tile_set:
		var source_regular: TileSetAtlasSource = tile_set.get_source(SOURCE_REGULAR_GRASS)
		if source_regular:
			for i in range(source_regular.get_tiles_count()):
				regular_grass_tiles.append(source_regular.get_tile_id(i))
				
		var source_flower: TileSetAtlasSource = tile_set.get_source(SOURCE_FLOWER_GRASS)
		if source_flower:
			for i in range(source_flower.get_tiles_count()):
				flower_grass_tiles.append(source_flower.get_tile_id(i))
				
		var source_stone: TileSetAtlasSource = tile_set.get_source(SOURCE_STONE_SLABS)
		if source_stone:
			for i in range(source_stone.get_tiles_count()):
				stone_path_tiles.append(source_stone.get_tile_id(i))
	
	generate_chunk(Vector2i(0, 0))

func _physics_process(delta: float) -> void:
	check_chunk_loading() # Check if we need a new chunk
	process_chunk_queue() # Process chunks gradually
	
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
			
			var source_id: int
			var atlas_coord: Vector2i
			
			# 1. Determine if this cell is part of a Stone Path "Blob"
			var noise_val = path_noise.get_noise_2d(world_x, world_y)
			
			if noise_val > PATH_THRESHOLD and not stone_path_tiles.is_empty():
				# It's a stone path blob
				source_id = SOURCE_STONE_SLABS
				atlas_coord = stone_path_tiles.pick_random()
			else:
				# 2. It's regular ground. Apply weights for Flowers vs Grass
				var spawn_chance = randf()
				if spawn_chance < 0.15 and not flower_grass_tiles.is_empty():
					# 15% chance for flowers
					source_id = SOURCE_FLOWER_GRASS
					atlas_coord = flower_grass_tiles.pick_random()
				else:
					# 85% chance for regular grass
					source_id = SOURCE_REGULAR_GRASS
					atlas_coord = regular_grass_tiles.pick_random() if not regular_grass_tiles.is_empty() else Vector2i(0, 0)
			
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
