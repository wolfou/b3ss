extends RigidBody3D

@onready var thrust_light1 = $ThrustLight
@onready var thrust_light2 = $ThrustLight2
@onready var thrust_sound = $ThrustSound
@onready var rotation_sound = $RotationSound
@onready var inventory = $PlayerInventory
@onready var hud_scene = preload("res://scenes/ui/hud.tscn")

@export var hud: CanvasLayer
@export var interaction_manager: Node
@export var pilot_controls: Node
@export var thrust_power: float = 50.0
@export var aux_thrust_power: float = 5.0
@export var rotation_power: float = 10.0

signal interaction_prompt_updated(text: String)

func _ready():
	hud = hud_scene.instantiate()
	hud.player = self
	add_child(hud)
	pilot_controls = $PilotControls
	interaction_manager = $InteractionManager

func _input(event):
	if event.is_action_pressed("trade_menu"):
		get_tree().change_scene_to_file("res://scenes/ui/menu_commerce.tscn")