class_name PlayerUi
extends CanvasLayer


@onready var texture_bar:TextureProgressBar = get_node("TextureProgressBar")
@onready var label:Label = get_node("Label")

func _ready() -> void:
	texture_bar.max_value = PlayerStats.max_health

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("q_key"):
		PlayerStats.current_health -= 10
	
	texture_bar.value = PlayerStats.current_health
	label.text = str(PlayerStats.current_health)
