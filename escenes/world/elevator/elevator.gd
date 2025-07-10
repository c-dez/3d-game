class_name Elevator
extends CharacterBody3D

@onready var collision: CollisionShape3D = get_node("CollisionShape3D")
@onready var floor_mesh: MeshInstance3D = get_node("FloorMesh")

func _ready() -> void:
	collision.shape.set_size(floor_mesh.mesh.get_size()) 


func _on_trigger_area_body_entered(body: Node3D) -> void:
	if body is Player:
		print(body.name)
	pass # Replace with function body.
