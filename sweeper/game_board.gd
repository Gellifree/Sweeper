extends Node3D

@export var tile_scene: PackedScene
@export var grid_size := 10
@export var tile_size:= 1.0

var tiles := {}

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
	print(neighbors)
	return neighbors

func mine_count(grid_position: Vector2i):
	var neighbor_list = get_neighbors(grid_position)
	var mine_counter = 0
	for neighbor in neighbor_list:
		if tiles[neighbor].is_mine == true:
			mine_counter += 1
	return mine_counter

func _ready() -> void:
	var offset = (grid_size -1) * tile_size / 2.0
	
	for x in range(grid_size):
		for z in range(grid_size):
			var tile = tile_scene.instantiate()
			tile.position = Vector3(x * tile_size - offset, 0, z * tile_size - offset)
			tile.grid_position = Vector2i(x,z)
			tiles[Vector2i(x,z)] = tile
			if x== 2 and z == 2:
				tile.is_mine = true
			if x== 2 and z == 3:
				tile.is_mine = true
			add_child(tile)
