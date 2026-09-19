extends Node3D

@onready var mesh: MeshInstance3D = $MeshInstance3D
var is_revealed := false

var is_mine := false

var grid_position: Vector2i

func reveal(neighbor_mines: int):
	if is_revealed:
		return
	
	is_revealed = true
	
	var material = StandardMaterial3D.new()
	if neighbor_mines == 0:
		material.albedo_color = Color(0.5, 0.5, 0.5)
	elif neighbor_mines == 1:
		material.albedo_color = Color(0.2, 0.8, 0.2)
	elif neighbor_mines == 2:
		material.albedo_color = Color(0.9, 0.8, 0.2)
	else:
		material.albedo_color = Color(0.9, 0.2, 0.2)
	if is_mine:
		material.albedo_color = Color(0.25, 0.02, 0.023, 1.0)
	
	mesh.material_override = material
