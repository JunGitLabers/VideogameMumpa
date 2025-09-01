extends CharacterBody3D

# Configuración de movimiento
@export var speed: float = 5.0
@export var jump_force: float = 4.5
@export var mouse_sensitivity: float = 0.002

# Referencias
@onready var camera_pivot = $CameraPivot
@onready var camera = $CameraPivot/Camera3D

# Variables de cámara
var camera_rotation: Vector2 = Vector2.ZERO

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	# Rotación de cámara con mouse
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Rotación horizontal (jugador)
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# Rotación vertical (cámara)
		camera_rotation.x -= event.relative.y * mouse_sensitivity
		camera_rotation.x = clamp(camera_rotation.x, -PI/2, PI/2)
		camera_pivot.rotation.x = camera_rotation.x
	
	# Tecla ESC para alternar captura de mouse
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			toggle_mouse_capture()
		
		# Tecla para salir del juego
		if event.keycode == KEY_Q:  # Cambié de "Quit" a KEY_Q para mayor claridad
			get_tree().quit()

func _physics_process(delta):
	# Movimiento del personaje
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	
	# Saltar
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	# Movimiento horizontal
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()

func toggle_mouse_capture():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
