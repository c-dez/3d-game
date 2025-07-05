class_name Player
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(_delta: float) -> void:
	move()
	jump()
	gravity(_delta)
	

	move_and_slide()


func move() -> void:
	var input_dir := Input.get_vector(Keybindings.left, Keybindings.right, Keybindings.forward, Keybindings.backwards)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	pass


func jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY


func gravity(_delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * _delta
