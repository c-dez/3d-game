class_name Actions
extends Node

@export var climb_speed: float = 4.0

@onready var player: Player = get_node("..")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(Keybindings.action):
		MoveStateMachine.current_state = MoveStateMachine.STATE.CLIMBING


func climb() -> void:
	if Input.is_action_pressed(Keybindings.climb):
		player.velocity.y = climb_speed
	elif Input.is_action_pressed(Keybindings.descend):
		player.velocity.y = -5.0
	else:
		player.velocity.y = 0.0
