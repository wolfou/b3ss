extends Node3D

@onready var player_scene = preload("res://scenes/player/player.tscn")
@onready var hud_scene = preload("res://scenes/ui/hud.tscn")
@onready var meteor_scene = preload("res://scenes/environment/meteor.tscn")
@onready var space_station_scene = preload("res://scenes/environment/space_station.tscn")

var player
var space_station
var hud
var meteors = []
var spatial_relation
signal meteor_destroyed

func _ready():
	player = player_scene.instantiate()
	add_child(player)
	space_station = space_station_scene.instantiate()
	var spawn_position = Vector3(0, -200,0)
	space_station.global_position = spawn_position
	space_station.look_at_from_position(spawn_position, Vector3.ZERO)
	add_child(space_station)
	hud = hud_scene.instantiate()
	add_child(hud)

	spatial_relation = SpatialRelation.new()
	add_child(spatial_relation)

	spawn_initial_meteors(100, 1000)
	update_closest_meteor()

func spawn_initial_meteors(count: int, volume_size: float):
	var half_size = volume_size / 2.0
	for i in range(count):
		var meteor = meteor_scene.instantiate()
		var spawn_position = Vector3(
			randf_range(-half_size, half_size),
			randf_range(-half_size, half_size),
			randf_range(-half_size, half_size)
		)
		meteor.global_position = spawn_position
		meteor.look_at_from_position(spawn_position, Vector3.ZERO)
		meteor.player = player
		meteor.destroyed.connect(_on_meteor_destroyed.bind(meteor))
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
	hud.spatial_relation = spatial_relation
