extends Node3D

@onready var camera_pitch: Node3D = $CameraPitch
@onready var camera: Camera3D = $CameraPitch/Camera3D

var rotating := false
var panning := false

@export var rotation_speed := 0.01
@export var zoom_speed := 2.0
@export var pan_speed := 0.02
@export var min_zoom := 8.0
@export var max_zoom := 25.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				if Input.is_key_pressed(KEY_SHIFT):
					panning = true
				else:
					rotating = true
			else:
				rotating = false
				panning = false
	
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			camera.position.z = max(min_zoom, camera.position.z - zoom_speed)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			camera.position.z = min(max_zoom, camera.position.z + zoom_speed)
	
	if event is InputEventMouseMotion:
		if rotating:
			rotation.y -= event.relative.x * rotation_speed
			camera_pitch.rotation.x = clamp(camera_pitch.rotation.x - event.relative.y  * rotation_speed, deg_to_rad(-80), deg_to_rad(-20))
		if panning:
			var movement = event.relative * pan_speed
			
			var right = camera.global_transform.basis.x
			var forward = camera.global_transform.basis.z
			
			right.y = 0
			forward.y = 0
			
			right = right.normalized()
			forward = forward.normalized()
			
			global_position -= right * movement.x
			global_position -= forward * movement.y
