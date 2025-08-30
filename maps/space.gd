extends Node3D

@onready var player_scene = preload("res://scenes/player/player.tscn")
@onready var camera_scene = preload("res://scenes/cameras/observer_camera.tscn")
@onready var hud_scene = preload("res://scenes/ui/hud.tscn")

func _ready():
	# Instancie le joueur
	var player = player_scene.instantiate()
	add_child(player)

	# Instancie la caméra
	var camera = camera_scene.instantiate()
	add_child(camera)
	camera.player = player  # Assigne la référence au joueur

	# Instancie le HUD
	var hud = hud_scene.instantiate()
	add_child(hud)
	camera.update_distance.connect(hud.on_update_distance)
