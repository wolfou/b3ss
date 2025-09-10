extends Camera3D

@export var player: RigidBody3D

func _ready():
	if player:
		player.add_child(self)
		position = Vector3(0, 0.5, 0.5)  # Position dans le cockpit

func _process(delta):
	if player:
		# Émet la distance (si nécessaire)
		var distance = global_transform.origin.distance_to(player.global_transform.origin)
