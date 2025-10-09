extends CharacterBody3D
const GlobalFunctions = preload("res://Assets/GlobalFunctions.gd");

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY: float = 0.002
var MOVEMENT_KIND = ""

# Variables para el sistema de salida
var quit_confirmation: ConfirmationDialog
var is_in_menu: bool = false

func _ready():
	# Crear el diálogo de confirmación
	quit_confirmation = ConfirmationDialog.new()
	quit_confirmation.dialog_text = "¿Estás seguro de que quieres salir del juego?"
	quit_confirmation.confirmed.connect(_on_quit_confirmed)
	quit_confirmation.canceled.connect(_on_quit_cancelled)
	add_child(quit_confirmation)
	
	# Configurar botones para responder con Enter/Espacio
	setup_dialog_buttons()

func setup_dialog_buttons():
	# Obtener los botones del diálogo
	var confirm_button = quit_confirmation.get_ok_button()
	var cancel_button = quit_confirmation.get_cancel_button()
	
	# Configurar focus para navegación con teclado
	confirm_button.focus_mode = Control.FOCUS_ALL
	cancel_button.focus_mode = Control.FOCUS_ALL
	
	# Conectar señales de teclado
	confirm_button.grab_focus()

func _get_key(event):
	if Input.is_action_just_pressed(event):
		print("Key: "+event+" pressed");

func _physics_process(delta: float) -> void:
	# Si estamos en el menú, no procesar movimiento
	if is_in_menu:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("go_left", "go_right", "go_up", "go_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):
	if is_in_menu:
		# Manejar entradas específicas del menú
		if event.is_action_pressed("ui_accept"):  # Enter
			if quit_confirmation.visible:
				# Simular clic en el botón con focus
				var focused_button = get_viewport().gui_get_focus_owner()
				if focused_button:
					focused_button.emit_signal("pressed")
		
		elif event.is_action_pressed("ui_cancel"):  # ESC
			_on_quit_cancelled()
			
		elif event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
			# Cambiar focus entre botones
			switch_focus()
	
	else:
		# Entradas normales del juego
		if event.is_action_pressed("Quit"):
			show_quit_confirmation()

func switch_focus():
	var confirm_button = quit_confirmation.get_ok_button()
	var cancel_button = quit_confirmation.get_cancel_button()
	
	var current_focus = get_viewport().gui_get_focus_owner()
	
	if current_focus == confirm_button:
		cancel_button.grab_focus()
	else:
		confirm_button.grab_focus()

func show_quit_confirmation():
	is_in_menu = true
	quit_confirmation.popup_centered()
	
	# Configurar focus inicial
	var cancel_button = quit_confirmation.get_cancel_button()
	cancel_button.grab_focus()  # Focus en "Cancelar" por defecto (más seguro)

func _on_quit_cancelled():
	is_in_menu = false
	quit_confirmation.hide()

func _on_quit_confirmed():
	print("Saliendo del juego...")
	get_tree().quit()
