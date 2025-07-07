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


func _ready() -> void:
	buffer_timers_settup()
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