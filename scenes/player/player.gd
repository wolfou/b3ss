extends RigidBody3D

@export var thrust_power: float = 20.0
@export var rotation_power: float = 1.0
@onready var thrust_light1 = $ThrustLight
@onready var thrust_light2 = $ThrustLight2
@onready var thrust_sound = $ThrustSound
@onready var rotation_sound = $RotationSound

func _physics_process(delta):
	# Gestion des thrusters
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
		apply_torque(Vector3.LEFT * rotation_power)
		is_rotating = true
	if Input.is_action_pressed("rotate_down"):
		apply_torque(Vector3.RIGHT * rotation_power)
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

	# Son de rotation
	if is_rotating:
		if not rotation_sound.playing:
			rotation_sound.play()
	else:
		rotation_sound.stop()
