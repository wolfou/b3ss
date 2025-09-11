extends Node3D

@onready var player_scene = preload("res://scenes/player/player.tscn")
@onready var hud_scene = preload("res://scenes/ui/hud.tscn")
@onready var meteor_scene = preload("res://scenes/environment/meteor.tscn")

var player
var hud
var current_meteor

signal meteor_destroyed

func _ready():
	player = player_scene.instantiate()
	add_child(player)
	hud = hud_scene.instantiate()
	add_child(hud)
	hud.player = player
	spawn_meteor()  # Premier spawn sans paramètres

func spawn_meteor():
	var meteor = meteor_scene.instantiate()
	var spawn_position = Vector3(
		randf_range(-50, 50),
		randf_range(-50, 50),
		-randf_range(50, 50)
	)
	meteor.global_position = spawn_position
	meteor.look_at_from_position(spawn_position, Vector3.ZERO)
	meteor.player = player
	add_child(meteor)
	meteor.destroyed.connect(_on_meteor_destroyed)
	current_meteor = meteor
	hud.meteor = current_meteor


func _on_meteor_destroyed():
	spawn_meteor()  # Respawn un nouvel astéroïde
