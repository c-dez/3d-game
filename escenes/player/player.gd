class_name Player
extends CharacterBody3D


const SPEED: float = 8.0
const JUMP_VELOCITY: float = 4.5

@export var player_camera: PlayerCamera
@onready var visuals: MeshInstance3D = get_node("Visuals")

func _ready() -> void:
	debug_start()

func _physics_process(_delta: float) -> void:
	move()
	jump()
	gravity(_delta)


	move_and_slide()


func move() -> void:
	# movimiento normalizado combinando los inputs de jugador con la direccion de que la camera mira
	var raw_input: Vector2 = Input.get_vector(Keybindings.left, Keybindings.right, Keybindings.forward, Keybindings.backwards)

	# obtiene los vectores de la camara
	var forward: Vector3 = player_camera.global_basis.z
	var right: Vector3 = player_camera.global_basis.x
	# ignorar  y de forward/right para mantener movimiento en z x constante
	forward.y = 0
	right.y = 0
	# combina los valores de camera vars y raw_input para crear un Vector3 para que "enfrente" siempre sea hacia donde la camara mira
	var direction: Vector3 = forward * raw_input.y + right * raw_input.x
	direction = direction.normalized()
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


func jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY


func gravity(_delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * _delta


func debug_start() -> void:
	# codigos para prevenir errores en _start
	if player_camera is not PlayerCamera:
		printerr("player_camara reference is invalid")