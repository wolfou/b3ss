extends RigidBody3D

@export var max_units: int = 5
var current_units: int = 5
var is_mining: bool = false
var mining_timer: float = 0.0
@onready var mining_sound = $MiningSound
var player
signal destroyed
var type = "Meteor"

func _physics_process(delta):
	if is_mining:
		mining_timer += delta
		if mining_timer >= 1.0:
			current_units -= 1
			mining_timer = 0.0
			player.inventory.add_resource("meteor_units", 1)
			if current_units <= 0:
				stop_mining()
				emit_signal("destroyed")
				queue_free()
	var space = get_parent()
	if player:
		var distance_to_meteor = global_position.distance_to(space.player.global_position)
		if distance_to_meteor <= 5.0:
			start_mining()
		else:
			if is_mining:
				stop_mining()

func start_mining():
	if not is_mining and current_units > 0:
		is_mining = true
		mining_sound.play()

func stop_mining():
	is_mining = false
	mining_sound.stop()
