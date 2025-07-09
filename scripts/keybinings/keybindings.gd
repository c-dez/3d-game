# autoload Keybindings.gd
extends Node


# Movement 
var forward: String = "forward"
var backwards: String = "backwards"
var left: String = "left"
var right: String = "right"

var buffer_active_time: float = 0.3
#jump
var jump: String = "jump"
var jump_buffer_timer: Timer

# Actions
var action: String = "action"
var action_buffer_timer: Timer

#climbing
var climb:String = "forward"
var descend:String = "backwards"


func _ready() -> void:
	set_jump_buffer_timer()
	set_action_buffer_timer()
	pass

func _process(_delta: float) -> void:
	# state_keys()
	pass


func buffer_jump() -> bool:
	#input buffer
	if Input.is_action_just_pressed(jump):
		jump_buffer_timer.start(buffer_active_time)
	return jump_buffer_timer.time_left > 0


func buffer_action()-> bool:
	if Input.is_action_just_pressed(action):
		action_buffer_timer.start(buffer_active_time)
	return action_buffer_timer.time_left > 0


func set_jump_buffer_timer() -> void:
	# jump
	jump_buffer_timer = Timer.new()
	jump_buffer_timer.one_shot = true
	jump_buffer_timer.autostart = false
	add_child(jump_buffer_timer)


func set_action_buffer_timer()->void:
	action_buffer_timer = Timer.new()
	action_buffer_timer.one_shot = true
	action_buffer_timer.autostart = false
	add_child(action_buffer_timer)
