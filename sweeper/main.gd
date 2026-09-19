extends Node3D

@onready var camera: Camera3D = $CameraRig/CameraPitch/Camera3D
@onready var game_board = $GameBoard

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			click_tile(event.position)


func click_tile(mouse_position: Vector2):
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_direction = camera.project_ray_normal(mouse_position)
	
	var ray_end = ray_origin + ray_direction * 1000.0
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	if result:
		var collider = result["collider"]
		var tile = collider.get_parent()
		var neighbors = game_board.get_neighbors(tile.grid_position)
		var mine_count = game_board.mine_count(tile.grid_position)
		print("Szomszédos aknák: ", mine_count)
		tile.reveal(mine_count)
