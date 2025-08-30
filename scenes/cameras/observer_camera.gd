extends Camera3D

@export var player: RigidBody3D
signal update_distance(distance)

func _process(delta):
	if player:
		look_at(player.global_transform.origin)
		var distance = global_transform.origin.distance_to(player.global_transform.origin)
		update_distance.emit(distance)
