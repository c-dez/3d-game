class_name Actions
extends Node

@export var climb_speed: float = 4.0

@onready var player: Player = get_node("..")
@onready var player_area: Area3D = get_node("../PlayerArea")

var can_climb: bool = false

func _process(_delta: float) -> void:
	change_state_between_moving_or_climbing()
	

func change_state_between_moving_or_climbing() -> void:
	if not can_climb and MoveStateMachine.current_state == MoveStateMachine.STATE.CLIMBING:
		MoveStateMachine.current_state = MoveStateMachine.STATE.MOVING

	match MoveStateMachine.current_state:
		MoveStateMachine.STATE.MOVING:
			if (Keybindings.buffer_action()) and can_climb:
				MoveStateMachine.current_state = MoveStateMachine.STATE.CLIMBING

		# ME GUSTA MAS SOLTARSE DE ESCALERA SOLO CON jump_climb()
		# MoveStateMachine.STATE.CLIMBING:
		# 	if Input.is_action_just_pressed(Keybindings.action):
		# 		MoveStateMachine.current_state = MoveStateMachine.STATE.MOVING
		# 		can_climb = false
		_:
			pass
		

func jump_climb() -> void:
	#sale de climbing y brinca
	if Input.is_action_just_pressed(Keybindings.jump):
		MoveStateMachine.current_state = MoveStateMachine.STATE.MOVING
		player.velocity.y = player._jump_velocity


	pass


func climb() -> void:
	# bloquear movimiento en X Z
	player.velocity.x = 0
	player.velocity.z = 0
	if Input.is_action_pressed(Keybindings.climb):
		player.velocity.y = climb_speed
	elif Input.is_action_pressed(Keybindings.descend):
		player.velocity.y = - climb_speed
	else:
		player.velocity.y = 0.0


func _on_player_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("Ladder"):
		can_climb = true


func _on_player_area_area_exited(area: Area3D) -> void:
	if area.is_in_group("Ladder"):
		can_climb = false
