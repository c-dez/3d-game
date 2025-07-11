class_name Elevator
extends Path3D

var loop: bool = false
var speed: float = 2.0

@onready var path: PathFollow3D = get_node("PathFollow3D")
@onready var animation : AnimationPlayer = get_node("AnimationPlayer")

func _ready() -> void:
	# if not loop:
	# 	animation.play("move")
	pass

func _physics_process(_delta: float) -> void:
	# path.progress += speed * _delta

	if Input.is_action_just_pressed(Keybindings.action):
		match path.progress_ratio:
			0.0:
				animation.play("move")
			1.0:
				animation.play_backwards("move")
				
			_:
				pass
	pass
