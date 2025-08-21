extends Node3D

@export var mouse_sensitivity: float = 0.002
@export var player_node: NodePath = ".."  # Valor por defecto: nodo padre

var camera_rotation: Vector2 = Vector2.ZERO
var player

func _ready():
	player = get_node(player_node)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	print("Player found: ", player.name if player else "None")

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if player:
			# Rotación horizontal del jugador
			player.rotate_y(-event.relative.x * mouse_sensitivity)
			
			# Rotación vertical de la cámara
			camera_rotation.x -= event.relative.y * mouse_sensitivity
			camera_rotation.x = clamp(camera_rotation.x, -PI/2, PI/2)
			rotation.x = camera_rotation.x

func toggle_mouse_capture():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
