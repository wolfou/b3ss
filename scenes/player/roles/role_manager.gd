extends Node

enum Role { PILOT, GUNNER, OBSERVER }
var current_role: Role = Role.PILOT

@onready var pilot_controls: Node
@onready var gunner_controls: Node
@onready var observer_controls: Node

func _ready():
	# Récupère les nœuds de contrôle (instanciés dans player.gd)
	pilot_controls = get_parent().get_node("PilotControls")
	# gunner_controls et observer_controls seront ajoutés plus tard

	_set_role(current_role)

func _set_role(role: Role):
	# Désactive tous les contrôles
	if pilot_controls:
		pilot_controls.set_process_mode(PROCESS_MODE_DISABLED)
	if gunner_controls:
		gunner_controls.set_process_mode(PROCESS_MODE_DISABLED)
	if observer_controls:
		observer_controls.set_process_mode(PROCESS_MODE_DISABLED)

	# Active le rôle sélectionné
	match role:
		Role.PILOT:
			if pilot_controls:
				pilot_controls.set_process_mode(PROCESS_MODE_INHERIT)
		Role.GUNNER:
			if gunner_controls:
				gunner_controls.set_process_mode(PROCESS_MODE_INHERIT)
		Role.OBSERVER:
			if observer_controls:
				observer_controls.set_process_mode(PROCESS_MODE_INHERIT)

func switch_to_pilot():
	current_role = Role.PILOT
	_set_role(current_role)

func switch_to_gunner():
	current_role = Role.GUNNER
	_set_role(current_role)

func switch_to_observer():
	current_role = Role.OBSERVER
	_set_role(current_role)
