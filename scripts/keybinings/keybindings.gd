# autoload Keybindings.gd
extends Node


# Movement 
var forward: String = "forward"
var backwards: String = "backwards"
var left: String = "left"
var right: String = "right"

#jump
var jump: String = "jump"
# buffer
var jump_buffer_timer: Timer
var buffer_active_time: float = 0.3

# Actions
var action: String = "action"

#climbing
var climb:String = "forward"
var descend:String = "backwards"


func _ready() -> void:
	buffer_timers_settup()
	pass

func _process(_delta: float) -> void:
	# state_keys()
	pass


func buffer_jump() -> bool:
	#input buffer
	if Input.is_action_just_pressed(jump):
		jump_buffer_timer.start(buffer_active_time)
	return jump_buffer_timer.time_left > 0


func buffer_timers_settup() -> void:
	# jump
	jump_buffer_timer = Timer.new()
	jump_buffer_timer.one_shot = true
	jump_buffer_timer.autostart = false
	add_child(jump_buffer_timer)

# un state machine da seguimiento a estado moverse, escalando escalera
# dependiendo de el estado se asignan y desasignan keybindings

# func state_keys() -> void:
# 	match MoveStateMachine.current_state:
# 		MoveStateMachine.STATE.MOVING:
# 			assign_moving_keys()
# 		MoveStateMachine.STATE.CLIMBING:
# 			assign_climbing_keys()
			
# 		_:
# 			pass

# func assign_moving_keys():
# 	forward = "forward"
# 	backwards = "backwards"
# 	left = "left"
# 	right = "right"

# func assign_climbing_keys():
# 	climb = "forward"
# 	descend = "backwards"

# func clear_keys():
# 	forward = ""
# 	backwards = ""
# 	left = ""
# 	right = ""