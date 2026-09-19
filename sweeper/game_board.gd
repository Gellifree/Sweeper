extends Node3D

@export var tile_scene: PackedScene
@export var grid_size := 10
@export var tile_size:= 1.0

func _ready() -> void:
	var offset = (grid_size -1) * tile_size / 2.0
	
	for x in range(grid_size):
		for z in range(grid_size):
			var tile = tile_scene.instantiate()
			tile.position = Vector3(x * tile_size - offset, 0, z * tile_size - offset)
			add_child(tile)
