extends Node3D

@onready var player_scene = preload("res://scenes/player/player.tscn")
@onready var meteor_scene = preload("res://scenes/environment/meteor.tscn")
@onready var space_station_scene = preload("res://scenes/environment/space_station.tscn")

var player
var space_station
var hud
var meteors = []
var spatial_relation
var angular_velocity: float = 0.14

func _ready():
	player = player_scene.instantiate()
	add_child(player)
	space_station = space_station_scene.instantiate()
	var spawn_position = Vector3(0, -1000,0)
	space_station.global_position = spawn_position
	add_child(space_station)

	spatial_relation = SpatialRelation.new()
	add_child(spatial_relation)

	spawn_initial_meteors(100, 1000)
	update_closest_meteor()


func spawn_initial_meteors(count: int, volume_size: float):
	var half_size = volume_size / 2.0
	var station_position = space_station.global_position
	var min_distance_from_station = 400.0 # Ajuste cette valeur

	for i in range(count):
		var meteor = meteor_scene.instantiate()
		var spawn_position: Vector3
		var attempts = 0
		var max_attempts = 10

		# Utilise une boucle while à la place de repeat:
		while true:
			spawn_position = Vector3(
				randf_range(-half_size, half_size),
				randf_range(-half_size, half_size),
				randf_range(-half_size, half_size)
			)
			attempts += 1
			if attempts > max_attempts:
				spawn_position = Vector3(half_size, half_size, half_size) # Position par défaut
				break
			if spawn_position.distance_to(station_position) >= min_distance_from_station:
				break

		meteor.global_position = spawn_position
		meteor.look_at_from_position(spawn_position, Vector3.ZERO)
		add_child(meteor)
		meteors.append(meteor)

func _on_meteor_destroyed(meteor):
	meteors.erase(meteor)
	update_closest_meteor()

func update_closest_meteor():
	if meteors.is_empty():
		return
	var closest_meteor = null
	var min_distance = INF
	for meteor in meteors:
		var distance = player.global_position.distance_to(meteor.global_position)
		if distance < min_distance:
			min_distance = distance
			closest_meteor = meteor
	spatial_relation.player = player
	spatial_relation.target = closest_meteor
	player.hud.spatial_relation = spatial_relation
