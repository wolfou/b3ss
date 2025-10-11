extends Node

@export var detection_radius: float = 5.0
var player
var current_interactable = null

func _ready():
	player = get_parent()

func _physics_process(_delta):
	_check_for_interactables()

func _check_for_interactables():
	var closest_object = null
	var min_distance = detection_radius

	for child in get_parent().get_parent().get_children():
		if child.is_in_group("interactables") and child != player:
			var distance = player.global_position.distance_to(child.global_position)
			if distance <= min_distance:
				closest_object = child
				break

	if closest_object != current_interactable:
		current_interactable = closest_object
		if current_interactable:
			get_parent().emit_signal("interaction_prompt_updated", current_interactable.type)
		else:
			get_parent().emit_signal("interaction_prompt_updated", "")
