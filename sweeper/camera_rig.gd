extends Node3D

@onready var camera_pitch: Node3D = $CameraPitch
@onready var camera: Camera3D = $CameraPitch/Camera3D

var rotating := false

@export var rotation_speed := 0.01
@export var zoom_speed := 2.0
@export var min_zoom := 8.0
@export var max_zoom := 25.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			rotating = event.pressed
	
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			camera.position.z = max(min_zoom, camera.position.z - zoom_speed)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			camera.position.z = min(max_zoom, camera.position.z + zoom_speed)
	
	if event is InputEventMouseMotion and rotating:
		rotation.y -= event.relative.x * 0.01
		camera_pitch.rotation.x = clamp(camera_pitch.rotation.x - event.relative.y  * 0.01, deg_to_rad(-80), deg_to_rad(-20))
