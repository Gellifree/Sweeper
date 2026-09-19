extends Node3D

@export var tile_scene: PackedScene
@export var grid_size := 10
@export var tile_size:= 1.0

var game_over := false

var win_counter := 0
var max_revealed_counter := 0

var tiles := {}

@export var max_mine_count := 20

var directions = [
	Vector2i(-1, -1),
	Vector2i(0, -1),
	Vector2i(1, -1),
	Vector2i(-1, 0),
	Vector2i(1, 0),
	Vector2i(-1, 1),
	Vector2i(0, 1),
	Vector2i(1, 1),
]

func get_neighbors(grid_position: Vector2i):
	var neighbors = []
	for direction in directions:
		if tiles.has(Vector2i(grid_position.x + direction.x, grid_position.y + direction.y)):
			var neighbor_position = grid_position + direction
			neighbors.append(neighbor_position)
	return neighbors

func mine_count(grid_position: Vector2i):
	if tiles[grid_position].is_mine == true:
		return 0
	var neighbor_list = get_neighbors(grid_position)
	var mine_counter = 0
	for neighbor in neighbor_list:
		if tiles[neighbor].is_mine == true:
			mine_counter += 1
	return mine_counter

func reveal_tile(grid_position: Vector2i):
	if game_over:
		return
	
	if tiles[grid_position].is_revealed == true:
		return
	var neighbors_list = get_neighbors(grid_position)
	var mine_count = mine_count(grid_position)
	
	tiles[grid_position].reveal(mine_count)
	win_counter += 1
	
	if tiles[grid_position].is_mine:
		print("GAME OVER")
		game_over = true
		return
		
	if win_counter == max_revealed_counter:
		print("YOU WIN")
		game_over = true
		return
	

	
	if mine_count == 0:
		for neigbor in neighbors_list:
			#reveal_tile(tiles[neigbor].grid_position)
			reveal_tile(neigbor)

func decide_mine_generation():
	var chance = randi_range(0,100)
	if(chance > 95):
		return true
	else:
		return false

func generate_board():
	var offset = (grid_size -1) * tile_size / 2.0
	
	var mines_in_map = 0
	for x in range(grid_size):
		for z in range(grid_size):
			var tile = tile_scene.instantiate()
			tile.position = Vector3(x * tile_size - offset, 0, z * tile_size - offset)
			tile.grid_position = Vector2i(x,z)
			tiles[Vector2i(x,z)] = tile
			
			if decide_mine_generation() == true:
				tile.is_mine = true
				mines_in_map += 1
			
			add_child(tile)
	max_revealed_counter = (grid_size * grid_size) - mines_in_map

func clear_board():
	for tile in tiles.values():
		tile.queue_free()
	tiles.clear()

func reset_game():
	game_over = false
	win_counter = 0
	max_revealed_counter = 0
	clear_board()
	generate_board()

func _ready() -> void:
	generate_board()
	
