class_name PlayerCamera
extends SpringArm3D


# @export var player: Player
@onready var camera: Camera3D = get_node("Camera3D")

var mouse_sens: float = 0.25 / 3 # 60 fps
var camera_input_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	# top_level = true
	# if player is not Player:
	# 	printerr("PlayerCamera reference to Player is invalid")

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta: float) -> void:
	var degres:int = 30
	# vertical
	rotation.x -= camera_input_direction.y * _delta
	#horizontal
	rotation.y -= camera_input_direction.x * _delta 
	# x clamp(vertical)
	rotation.x = clamp(rotation.x, deg_to_rad(-degres), deg_to_rad(degres))
	#reset
	camera_input_direction = Vector2.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_input_direction = event.screen_relative * mouse_sens
	pass
