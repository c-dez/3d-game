class_name Player
extends CharacterBody3D


@export var player_camera: PlayerCamera
# movement
var move_speed: float = 8.0
var jump_force: float = 4.5

# variables para rotar mesh segun la direccion de movimiento
@onready var skin: MeshInstance3D = get_node("Visuals")
var last_movement_direction := Vector3.FORWARD
var rotation_speed: float = 12.0

# better jump
var jump_height: float = 1.0
var jump_time_to_peak: float = 0.4
var jump_time_to_descend: float = 0.5
var jump_velocity
var jump_gravity
var jump_fall_gravity


func _ready() -> void:
	debug_start()

	jump_velocity = 2.0 * jump_height / jump_time_to_peak
	jump_gravity = 2.0 * jump_height / (jump_time_to_peak * jump_time_to_peak)
	jump_fall_gravity = 2.0 * jump_height / (jump_time_to_descend * jump_time_to_descend)



func _physics_process(_delta: float) -> void:
	move()
	jump()
	gravity(_delta)

	move_and_slide()


func rotate_skin(direction: Vector3) -> void:
	var _delta: float = get_process_delta_time()

	if direction.length() > 0.5:
		last_movement_direction = direction

	# Calculamos el ángulo Y en el plano XZ
	var target_angle = atan2(last_movement_direction.x, last_movement_direction.z) + PI
	
	# Interpolación suave usando lerp_angle
	skin.rotation.y = lerp_angle(skin.rotation.y, target_angle, rotation_speed * _delta)


func move() -> void:
	# movimiento normalizado combinando los inputs de jugador con la direccion de que la camera mira
	var raw_input: Vector2 = Input.get_vector(Keybindings.left, Keybindings.right, Keybindings.forward, Keybindings.backwards)

	# obtiene los vectores de la camara
	var forward: Vector3 = player_camera.global_basis.z
	var right: Vector3 = player_camera.global_basis.x
	# ignorar Y de forward/right para mantener movimiento en Z X constante
	forward.y = 0
	right.y = 0
	# combina los valores forward/right y raw_input para crear un Vector3 para que "enfrente" siempre sea hacia donde la camara mira
	var direction: Vector3 = forward * raw_input.y + right * raw_input.x
	direction = direction.normalized()
	if direction != Vector3.ZERO:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)
	# rotate skin
	rotate_skin(direction)


func jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force


func gravity(_delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * _delta


func debug_start() -> void:
	# codigos para reportar errores
	if player_camera is not PlayerCamera:
		printerr("referencia a  '@export var player_camera :PlayerCamera' es incorrecta")
		set_process(false)

	if not Keybindings:
		printerr("keybindings son referenciados en autoload Keybindings.gs")
		set_process(false)
