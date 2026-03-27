extends TileMapLayer

@export var width: int = 100
@export var height: int = 100
@export var tile_source_id: int = 0
@export var tile_columns: int = 4  # How many tiles across in your tileset
@export var tile_rows: int = 4     # How many tiles down in your tileset

func _ready():
	generate_random_map()

func generate_random_map():
	clear()
	
	for x in range(width):
		for y in range(height):
			# Pick random tile from your tileset grid
			var random_x = randi() % tile_columns
			var random_y = randi() % tile_rows
			set_cell(Vector2i(x, y), tile_source_id, Vector2i(random_x, random_y))
