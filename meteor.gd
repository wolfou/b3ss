extends RigidBody3D

@export var max_units: int = 5  # Unités totales dans l'astéroïde
var current_units: int = 5     # Unités restantes
var is_mining: bool = false    # État du minage
var mining_timer: float = 0.0  # Timer pour le minage

@onready var mining_sound = $MiningSound
@onready var mining_light = $MiningLight

func _physics_process(delta):
	if is_mining:
		mining_timer += delta
		if mining_timer >= 1.0:  # 1 seconde pour miner une unité
			current_units -= 1
			mining_timer = 0.0
			print("Unité minée ! Il reste %d unités." % current_units)

			if current_units <= 0:
				is_mining = false
				mining_sound.stop()
				mining_light.visible = false
				queue_free()  # Détruit l'astéroïde quand il n'a plus de ressources

func start_mining():
	if not is_mining and current_units > 0:
		is_mining = true
		mining_sound.play()
		mining_light.visible = true

func stop_mining():
	is_mining = false
	mining_sound.stop()
	mining_light.visible = false
