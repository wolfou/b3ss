extends RigidBody3D

@export var thrust_power: float = 20.0
@export var aux_thrust_power: float = 1.0
@export var rotation_power: float = 1.0
@onready var thrust_light1 = $ThrustLight
@onready var thrust_light2 = $ThrustLight2
@onready var thrust_sound = $ThrustSound
@onready var rotation_sound = $RotationSound

@onready var mining_light = $MiningLight  # Ajoute une lumière directionnelle pour le minage
var meteor;

func _physics_process(delta):
	# Gestion du propulseur principal (avant/arrière)
	var is_thrusting = Input.is_action_pressed("thrust_forward")
	thrust_light1.visible = is_thrusting
	thrust_light2.visible = is_thrusting
	if is_thrusting:
		if not thrust_sound.playing:
			thrust_sound.play()
		apply_central_force(-global_transform.basis.z * thrust_power)
	else:
		thrust_sound.stop()

	# Gestion des rotations
	var is_rotating = false
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3.BACK * rotation_power)
		is_rotating = true
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3.FORWARD * rotation_power)
		is_rotating = true
	if Input.is_action_pressed("rotate_up"):
		apply_torque(Vector3.RIGHT * rotation_power)
		is_rotating = true
	if Input.is_action_pressed("rotate_down"):
		apply_torque(Vector3.LEFT * rotation_power)
		is_rotating = true
	if Input.is_action_pressed("roll_left"):
		apply_torque(Vector3.UP * rotation_power)
		is_rotating = true
	if Input.is_action_pressed("roll_right"):
		apply_torque(Vector3.DOWN * rotation_power)
		is_rotating = true

	# Arrêt instantané des rotations
	if Input.is_action_pressed("stop_rotation"):
		angular_velocity = Vector3.ZERO
		is_rotating = true

	# Propulseurs auxiliaires (haut/bas, droite/gauche, avant/arrière)
	var is_aux_thrusting = false

	# Propulseur auxiliaire haut
	if Input.is_action_pressed("aux_thrust_up"):
		apply_central_force(global_transform.basis.y * aux_thrust_power)
		is_aux_thrusting = true

	# Propulseur auxiliaire bas
	if Input.is_action_pressed("aux_thrust_down"):
		apply_central_force(-global_transform.basis.y * aux_thrust_power)
		is_aux_thrusting = true

	# Propulseur auxiliaire gauche
	if Input.is_action_pressed("aux_thrust_left"):
		apply_central_force(-global_transform.basis.x * aux_thrust_power)
		is_aux_thrusting = true

	# Propulseur auxiliaire droite
	if Input.is_action_pressed("aux_thrust_right"):
		apply_central_force(global_transform.basis.x * aux_thrust_power)
		is_aux_thrusting = true

	# Propulseur auxiliaire avant (secondaire)
	if Input.is_action_pressed("aux_thrust_forward"):
		apply_central_force(global_transform.basis.z * aux_thrust_power)
		is_aux_thrusting = true

	# Propulseur auxiliaire arrière (secondaire)
	if Input.is_action_pressed("aux_thrust_backward"):
		apply_central_force(-global_transform.basis.z * aux_thrust_power)
		is_aux_thrusting = true

	# Son pour les propulseurs auxiliaires et les rotations
	if is_rotating or is_aux_thrusting:
		if not rotation_sound.playing:
			rotation_sound.play()
	else:
		rotation_sound.stop()
		
	# Gestion du minage automatique
	if meteor:
		var distance_to_meteor = global_position.distance_to(meteor.global_position)
		if distance_to_meteor <= 5.0:  # 5 mètres pour miner
			mining_light.visible = true
			mining_light.look_at_from_position(global_position, meteor.global_position)
			meteor.start_mining()
		else:
			mining_light.visible = false
			if meteor.is_mining:
				meteor.stop_mining()
