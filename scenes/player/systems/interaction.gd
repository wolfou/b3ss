extends Node

var player: RigidBody3D
var current_interactable: Node = null

func _ready():
	player = get_parent()

func _physics_process(_delta):
	_check_interaction_input()

func _check_interaction_input():
	if Input.is_action_just_pressed("interact") and current_interactable:
		_handle_interaction(current_interactable)

func _handle_interaction(target: Node):
	print("coucou")

func set_interactable(target: Node):
	current_interactable = target
	if target:
		player.emit_signal("interaction_prompt_updated", target.name)
	else:
		player.emit_signal("interaction_prompt_updated", "")
