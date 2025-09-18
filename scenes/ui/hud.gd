extends CanvasLayer

@export var spatial_relation: SpatialRelation
@onready var target_info = $TargetInfo  # Renommé

func _physics_process(delta):
	if spatial_relation:
		update_target_info()

func update_target_info():
	var data = spatial_relation.get_target_data()
	target_info.text = """
	%s
	DIST:  %.1f m
	ALIGN: %.1f° (Dev: %.1f°)
	TRAJ:  %.1f° (Dev: %.1f°)
	CLOSE: %.1f m/s
	IMPACT: %s
	""" % [
		data.name,  # Nom de la cible en premier
		data.distance,
		data.alignment.error, data.alignment.deviation,
		data.trajectory.error, data.trajectory.deviation,
		data.approach.speed,
		"%.1f sec" % data.approach.time_to_impact if data.approach.time_to_impact > 0 else "N/A"
	]
	target_info.modulate = Color(0.5, 1, 0.5)  # Vert fluo
