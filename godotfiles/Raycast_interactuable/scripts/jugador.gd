extends CharacterBody3D

@onready var raycast = $Camera3D/RayCast3D
var collider = null
var velocidad:int = 5
var direccion:Vector3
var mouse_sensitivity = 0.003
var mouse_sensitivity2 = 0.1
@onready var camera:Camera3D = $Camera3D
var pitch = 0.0

const GRAVEDAD: float = 9.8 

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensitivity
		pitch = clamp(pitch - event.relative.y * mouse_sensitivity, -90, 90)
		camera.rotation_degrees.x = pitch
		pitch = clamp(pitch - event.relative.y * mouse_sensitivity2, -90, 90)
		camera.rotation_degrees.x = pitch

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= GRAVEDAD * delta 
		
	if raycast.is_colliding():
		collider = raycast.get_collider()
		if collider != null:
			if Input.is_action_just_pressed("E"):
				if collider.has_method("interact"):
					collider.interact()
	else:
		collider = null
		
	caminar()
	move_and_slide()
	

	
func _process(_delta):
	ocultar_raton()
	
func caminar(): 
	direccion = transform.basis * Vector3(Input.get_axis("izquierda","derecha"),0,Input.get_axis("adelante","atras")).normalized()
	
	velocity.x = direccion.x * velocidad
	velocity.z = direccion.z * velocidad


func ocultar_raton():
	if Input.is_action_just_pressed("ocultar_raton"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
