extends Node3D
@onready var player_scene = preload("res://scenes/player/player.tscn")
@onready var hud_scene = preload("res://scenes/ui/hud.tscn")
@onready var meteor_scene = preload("res://scenes/environment/meteor.tscn")

func _ready():
	var player = player_scene.instantiate()
	add_child(player)
	var hud = hud_scene.instantiate()
	add_child(hud)
	hud.player = player  # Passe la référence du joueur au HUD
	var meteor = spawn_meteor()
	hud.meteor = meteor  # Passe la référence du météorite au HUD
	player.meteor = meteor

func spawn_meteor():
	var meteor = meteor_scene.instantiate()
	var spawn_position = Vector3(
		randf_range(-50, 50),
		randf_range(-50, 50),
		-randf_range(50, 50)
	)
	meteor.global_position = spawn_position
	meteor.look_at_from_position(spawn_position, Vector3.ZERO)
	add_child(meteor)
	return meteor
