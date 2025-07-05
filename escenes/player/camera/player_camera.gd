class_name PlayerCamera
extends SpringArm3D


@export var player: Player
@onready var camera: Camera3D = get_node("Camera3D")

func _ready() -> void:
	if player is not Player:
		printerr("PlayerCamera reference to Player is invalid")
