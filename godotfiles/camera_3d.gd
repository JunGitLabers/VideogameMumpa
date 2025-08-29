extends Camera3D

@export var target_node: Node3D  # Asigna el nodo objetivo (ej: el personaje)
@export var max_distance: float = 4.0  # Distancia máxima deseada
@export var collision_mask: int = 1  # Capa de colisión para paredes
@export var smooth_speed: float = 10.0  # Suavizado del movimiento
@export var collision_offset: float = 0.2  # Offset para evitar que la cámara se pegue a la pared

var ray_cast: RayCast3D
var current_distance: float = 0.0

func _ready():
	# Crear el RayCast3D como hijo de la cámara
	ray_cast = RayCast3D.new()
	add_child(ray_cast)
	ray_cast.enabled = true
	ray_cast.collide_with_areas = false
	ray_cast.collide_with_bodies = true
	ray_cast.collision_mask = collision_mask
	
	# Inicializar la distancia actual
	current_distance = max_distance

func _process(delta):
	if !target_node:
		return

	# Posicionar el RayCast en el objetivo y apuntar hacia la cámara
	ray_cast.global_position = target_node.global_position
	ray_cast.target_position = global_position - target_node.global_position

	# Calcular la dirección y distancia deseada
	var direction = (global_position - target_node.global_position).normalized()
	var desired_distance = max_distance

	# Si hay colisión, acortar la distancia
	if ray_cast.is_colliding():
		var collision_point = ray_cast.get_collision_point()
		desired_distance = target_node.global_position.distance_to(collision_point) - collision_offset
		
		# Asegurarse de que la distancia no sea negativa
		desired_distance = max(desired_distance, 0.1)
	else:
		# Si no hay colisión, restaurar gradualmente la distancia máxima
		desired_distance = max_distance

	# Suavizar la transición de distancia
	current_distance = lerp(current_distance, desired_distance, smooth_speed * delta)

	# Posición objetivo de la cámara
	var target_position = target_node.global_position + direction * current_distance

	# Suavizar el movimiento (opcional)
	global_position = global_position.lerp(target_position, smooth_speed * delta)

	# Asegurar que la cámara siempre mire al objetivo
	look_at(target_node.global_position)
