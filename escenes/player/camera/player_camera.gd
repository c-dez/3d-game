class_name PlayerCamera
extends SpringArm3D


@export var player: Player
@onready var camera: Camera3D = get_node("Camera3D")

var mouse_sens: float = 0.25 / 3 # 60 fps
var camera_input_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	# top_level = true
	if player is not Player:
		printerr("PlayerCamera reference to Player is invalid")

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta: float) -> void:
	print(camera_input_direction)

func _unhandled_input(event: InputEvent) -> void:
	if event:
		camera_input_direction = event.screen_relative * mouse_sens
	pass