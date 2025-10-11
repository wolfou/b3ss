extends Node

var player: RigidBody3D

func _ready():
	player = get_parent()

func _physics_process(_delta):
	if not player:
		return

	# Gestion du propulseur principal (avant/arrière)
	var is_thrusting = Input.is_action_pressed("thrust_forward")
	player.thrust_light1.visible = is_thrusting
	player.thrust_light2.visible = is_thrusting
	if is_thrusting:
		if not player.thrust_sound.playing:
			player.thrust_sound.play()
		player.apply_central_force(-player.global_transform.basis.z * player.thrust_power)
	else:
		player.thrust_sound.stop()

	# Rotations
	var is_rotating = false
	if Input.is_action_pressed("rotate_left"):
		player.apply_torque(-player.global_transform.basis.z * player.rotation_power)
		is_rotating = true
	if Input.is_action_pressed("rotate_right"):
		player.apply_torque(player.global_transform.basis.z * player.rotation_power)
		is_rotating = true
	if Input.is_action_pressed("rotate_up"):
		player.apply_torque(player.global_transform.basis.x * player.rotation_power)
		is_rotating = true
	if Input.is_action_pressed("rotate_down"):
		player.apply_torque(-player.global_transform.basis.x * player.rotation_power)
		is_rotating = true
	if Input.is_action_pressed("roll_left"):
		player.apply_torque(player.global_transform.basis.y * player.rotation_power)
		is_rotating = true
	if Input.is_action_pressed("roll_right"):
		player.apply_torque(-player.global_transform.basis.y * player.rotation_power)
		is_rotating = true

	# Arrêt instantané des rotations
	if Input.is_action_pressed("stop_rotation"):
		player.angular_velocity = Vector3.ZERO
		is_rotating = true

	# Propulseurs auxiliaires (haut/bas, droite/gauche, avant/arrière)
	var is_aux_thrusting = false
	# Propulseur auxiliaire haut
	if Input.is_action_pressed("aux_thrust_up"):
		player.apply_central_force(player.global_transform.basis.y * player.aux_thrust_power)
		is_aux_thrusting = true
	# Propulseur auxiliaire bas
	if Input.is_action_pressed("aux_thrust_down"):
		player.apply_central_force(-player.global_transform.basis.y * player.aux_thrust_power)
		is_aux_thrusting = true
	# Propulseur auxiliaire gauche
	if Input.is_action_pressed("aux_thrust_left"):
		player.apply_central_force(-player.global_transform.basis.x * player.aux_thrust_power)
		is_aux_thrusting = true
	# Propulseur auxiliaire droite
	if Input.is_action_pressed("aux_thrust_right"):
		player.apply_central_force(player.global_transform.basis.x * player.aux_thrust_power)
		is_aux_thrusting = true
	# Propulseur auxiliaire avant (secondaire)
	if Input.is_action_pressed("aux_thrust_forward"):
		player.apply_central_force(player.global_transform.basis.z * player.aux_thrust_power)
		is_aux_thrusting = true
	# Propulseur auxiliaire arrière (secondaire)
	if Input.is_action_pressed("aux_thrust_backward"):
		player.apply_central_force(-player.global_transform.basis.z * player.aux_thrust_power)
		is_aux_thrusting = true

	# Son pour les propulseurs auxiliaires et les rotations
	if is_rotating or is_aux_thrusting:
		if not player.rotation_sound.playing:
			player.rotation_sound.play()
	else:
		player.rotation_sound.stop()
	_check_interaction_input()

func _check_interaction_input():
	if Input.is_action_just_pressed("interact"):
		if player.interaction_manager.current_interactable:
			_handle_interaction(player.interaction_manager.current_interactable)

func _handle_interaction(target: Node):
	if target.type == "Meteor":
		target.queue_free()
