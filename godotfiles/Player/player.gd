extends CharacterBody3D
const GlobalFunctions = preload("res://Assets/GlobalFunctions.gd");

@export var SPEED: float = 2.0
@export var JUMP_VELOCITY: float = 4.5
@export var MOUSE_SENSITIVITY: float = 0.0005
var MOVEMENT_KIND = ""

@onready var camera_3d: Camera3D = $CameraPivot/Camera3D
var pitch: float =0.8 #tope vertical de la camara

func _ready() -> void: 
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)


func _get_key(event):
	if Input.is_action_just_pressed(event):
		print("Key: "+event+" pressed");

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("go_left", "go_right", "go_up", "go_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
