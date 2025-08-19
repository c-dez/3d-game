class_name Player
extends CharacterBody3D
# controla todo lo relacionado a movimiento/ camera

@export_group("Movimiento")
@export var move_speed: float = 12.0

# better jump
# la combinacion de estas variables modifica propiedades de salto y gravedad
@export_group("Salto")
@export var jump_height: float = 8.0
@export var jump_time_to_peak: float = 0.4
@export var jump_time_to_descend: float = 0.5

# variables para rotar mesh segun la direccion de movimiento
@onready var player_camera: PlayerCamera = get_node("PlayerCamera")
@onready var skin: MeshInstance3D = get_node("Visuals")
var last_movement_direction := Vector3.FORWARD
const _ROTATION_SPEED: float = 12.0

# se calcula en calculate_better_jump()
var _jump_velocity: float
var _jump_gravity: float
var _jump_fall_gravity: float

#coyote time
var _coyote_time_max: float = 0.2
var _coyote_time_counter: float = 0.0

# ClimbLadder node
@onready var climb_ladder: ClimbLadder = get_node("ClimbLadder")


func _ready() -> void:
	calculate_better_jump()


func _physics_process(_delta: float) -> void:
	match MoveStateMachine.current_state:
		MoveStateMachine.STATE.MOVING:
			move()
			jump(_delta)
			coyote_time_jump(_delta)
			gravity(_delta)

		MoveStateMachine.STATE.CLIMBING_LADDER:
			climb_ladder.climb()
			climb_ladder.jump_climb()
		_:
			pass

	player_camera.set_skin_visible_by_camera_distance(skin,1.0)
	move_and_slide()


func rotate_skin(direction: Vector3) -> void:
	var _delta: float = get_process_delta_time()

	if direction.length() > 0.0:
		last_movement_direction = direction

	# Calculamos el ángulo Y(rotacion horizontal) en el plano XZ
	var target_angle = atan2(last_movement_direction.x, last_movement_direction.z) + PI
	
	# Interpolación suave usando lerp_angle
	skin.rotation.y = lerp_angle(skin.rotation.y, target_angle, _ROTATION_SPEED * _delta)


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


func coyote_time_jump(_delta) -> void:
	# cuando no esta en suelo empieza cuenta regresiva
	if is_on_floor():
		_coyote_time_counter = _coyote_time_max
	else:
		_coyote_time_counter -= _delta
	# coyote jump
	if not is_on_floor() and _coyote_time_counter > 0:
		if Input.is_action_just_pressed(Keybindings.jump):
			velocity.y = _jump_velocity


func jump(_delta: float) -> void:
	if Keybindings.buffer_jump() and is_on_floor():
		velocity.y = _jump_velocity


func gravity(_delta) -> void:
	if not is_on_floor():
		if velocity.y < 0.0:
			velocity.y -= _jump_fall_gravity * _delta
		else:
			velocity.y -= _jump_gravity * _delta


func calculate_better_jump() -> void:
	_jump_velocity = 2.0 * jump_height / jump_time_to_peak
	_jump_gravity = 2.0 * jump_height / (jump_time_to_peak * jump_time_to_peak)
	_jump_fall_gravity = 2.0 * jump_height / (jump_time_to_descend * jump_time_to_descend)
