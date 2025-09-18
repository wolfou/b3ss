# res://scripts/spatial/spatial_relation.gd
extends Node
class_name SpatialRelation

@export var player: Node3D
@export var target: Node3D

var target_data: Dictionary = {
	"name": "Unknown",
	"distance": 0.0,
	"alignment": {"error": 0.0, "deviation": 0.0},
	"trajectory": {"error": 0.0, "deviation": 0.0},
	"approach": {"speed": 0.0, "time_to_impact": -1.0}
}

func _physics_process(delta):
	if player and target:
		update_target_data()

func update_target_data():
	target_data.name = target.type
	var to_target = (target.global_position - player.global_position)
	var distance = to_target.length()
	if distance < 0.1: return

	var to_target_norm = to_target.normalized()
	var player_forward = -player.global_transform.basis.z.normalized()
	var player_right = player.global_transform.basis.x

	# Mise à jour des données structurées
	target_data.distance = distance

	target_data.alignment.error = rad_to_deg(to_target_norm.angle_to(player_forward))
	target_data.alignment.deviation = rad_to_deg(
		atan2(to_target_norm.dot(player_right), to_target_norm.dot(player_forward))
	)

	var player_vel = player.linear_velocity if player.has_method("get_linear_velocity") else Vector3.ZERO
	if player_vel.length() > 0.1:
		var trajectory_dir = player_vel.normalized()
		target_data.trajectory.error = rad_to_deg(trajectory_dir.angle_to(to_target_norm))
		var rel_dir = to_target_norm.cross(trajectory_dir)
		target_data.trajectory.deviation = rad_to_deg(atan2(rel_dir.length(), to_target_norm.dot(trajectory_dir)))
		if rel_dir.dot(Vector3.UP) < 0:
			target_data.trajectory.deviation = -target_data.trajectory.deviation
	else:
		target_data.trajectory.error = 0
		target_data.trajectory.deviation = 0

	var target_vel = target.linear_velocity if target.has_method("get_linear_velocity") else Vector3.ZERO
	var relative_vel = target_vel - player_vel
	target_data.approach.speed = -relative_vel.dot(to_target_norm)

	if target_data.approach.speed > 0:
		target_data.approach.time_to_impact = target_data.distance / target_data.approach.speed
	else:
		target_data.approach.time_to_impact = -1

# Accesseur pratique
func get_target_data():
	return target_data
