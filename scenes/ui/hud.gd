extends CanvasLayer

@onready var player = null
@onready var meteor = null
@onready var hud_label = $HUDLabel

func _physics_process(delta):
	if player and meteor and hud_label:
		# 1. Distance
		var distance = player.global_position.distance_to(meteor.global_position)

		# 2. Calcul des directions et angles
		var to_target = meteor.global_position - player.global_position
		var ship_forward = -player.global_transform.basis.z

		if to_target.length() > 0.1:
			to_target = to_target.normalized()
		if ship_forward.length() > 0.1:
			ship_forward = ship_forward.normalized()

		# Angle d'alignement (puissance de l'erreur)
		var alignment_angle = rad_to_deg(to_target.angle_to(ship_forward))

		# Angle de déviation latérale (direction de l'erreur)
		var ship_right = player.global_transform.basis.x
		var alignment_deviation = rad_to_deg(
			atan2(to_target.dot(ship_right), to_target.dot(ship_forward))
		)

		# Angle de trajectoire (puissance de l'erreur)
		var ship_velocity = player.linear_velocity if player.has_method("get_linear_velocity") else Vector3.ZERO
		var trajectory_angle = 0
		var trajectory_deviation = 0

		if ship_velocity.length() > 0.1:
			var trajectory_dir = ship_velocity.normalized()
			trajectory_angle = rad_to_deg(trajectory_dir.angle_to(to_target))

			# Calcul de la déviation pour la trajectoire
			var rel_dir = to_target.cross(trajectory_dir)
			trajectory_deviation = rad_to_deg(atan2(rel_dir.length(), to_target.dot(trajectory_dir)))
			if rel_dir.dot(Vector3.UP) < 0:
				trajectory_deviation = -trajectory_deviation

		# 3. Calcul des vitesses
		var player_vel = Vector3.ZERO
		var meteor_vel = Vector3.ZERO

		if player.has_method("get_linear_velocity"):
			player_vel = player.linear_velocity
		if meteor.has_method("get_linear_velocity"):
			meteor_vel = meteor.linear_velocity

		var relative_velocity = meteor_vel - player_vel
		var closing_speed = 0
		if to_target.length() > 0.1:
			closing_speed = -relative_velocity.dot(to_target.normalized())

		# 4. Temps avant impact
		var time_to_impact = -1
		var impact_str = "N/A"
		if closing_speed > 0 and distance > 0.1:
			time_to_impact = distance / closing_speed
			impact_str = "%.1f" % time_to_impact

		# Création de la chaîne de texte
		var hud_text = """
		DIST: %.1f m
		ALIGN: %.1f° (Dev: %.1f°)
		TRAJ: %.1f° (Dev: %.1f°)
		CLOSE: %.1f m/s
		IMPACT: %s sec
		"""

		# Application du formatage
		hud_text = hud_text % [
			distance,
			alignment_angle, alignment_deviation,
			trajectory_angle, trajectory_deviation,
			closing_speed,
			impact_str
		]

		# Affichage
		hud_label.text = hud_text
		hud_label.modulate = Color(0.5, 1, 0.5)  # Vert fluo
