extends CharacterBody3D

# Constantes deben estar en mayúsculas según convención
const SPEED = 5.0
const JUMP_VELOCITY = 4.5  # Nota: "VELOCITY" estaba mal escrito como "VELOCITY"

# Variables exportadas/onready
@onready var raycast = $CameraPivot/Camera3D/RayCast3D
@onready var camera_pivot = $CameraPivot  # Nota: Había un error tipográfico en "camera_pivot"

# Variables miembro
var collider = null
var mouse_sensitivity = 0.02  # Nota: "sensitivity" estaba mal escrito como "sesitivity"

func _physics_process(delta: float) -> void:
	# Interacción con raycast
	if raycast.is_colliding():
		collider = raycast.get_collider()
		if collider != null and collider.has_method("interact"):
			collider.interact()
	
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Movimiento (esto debería estar en _physics_process)
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Back")  # Nota: "Forward" estaba mal escrito como "Foward"
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

# Nota: El decorador @warning_ignore debe estar en la línea anterior a la función
@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:  # Nota: "MODE" estaba mal escrito como "MODE"
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		# Limitar rotación (añadido acento en comentario)
		camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -deg_to_rad(70), deg_to_rad(70))
