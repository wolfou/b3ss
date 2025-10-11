extends CanvasLayer

@export var spatial_relation: SpatialRelation
@onready var target_info = $TargetInfo
@onready var ship_info = $ShipInfo
@onready var interaction_prompt = $InteractionPrompt
var player: Node

func _ready():
	ship_info.position = Vector2(1000, 20)
	target_info.position = Vector2(20, 20)
	interaction_prompt.position = Vector2(570, 600)
	target_info.modulate = Color(0.5, 1, 0.5)
	ship_info.modulate = Color(0.5, 1, 0.5)
	interaction_prompt.modulate = Color(0.5, 1, 0.5)
	hide_interaction_prompt()

	if player:
		player.interaction_prompt_updated.connect(_on_interaction_prompt_updated)
		player.inventory.resource_updated.connect(_on_resource_updated)

func _on_interaction_prompt_updated(text: String):
	if text == "":
		hide_interaction_prompt()
	elif text == "Meteor":
		show_interaction_prompt("Appuyez sur F pour miner")
	else:
		show_interaction_prompt(text)

func _physics_process(_delta):
	update_ship_info()
	if spatial_relation:
		update_target_info()

func update_target_info():
	var data = spatial_relation.get_target_data()
	target_info.text = """%s
	DIST:  %.1f m
	ALIGN: %.1f° (Dev: %.1f°)
	TRAJ:  %.1f° (Dev: %.1f°)
	CLOSE: %.1f m/s
	IMPACT: %s
	""" % [
		data.name,
		data.distance,
		data.alignment.error, data.alignment.deviation,
		data.trajectory.error, data.trajectory.deviation,
		data.approach.speed,
		"%.1f sec" % data.approach.time_to_impact if data.approach.time_to_impact > 0 else "N/A"
	]


func update_ship_info():
	if not player:
		ship_info.text = "Player not found"
		return

	var inv = player.inventory
	ship_info.text = """METEOR: %d
	CREDITS: %d
	""" % [
		inv.get_resource("meteor_units"),
		inv.get_resource("credits")
	]

func _on_resource_updated(_resource_name: String, _new_value: int):
	update_ship_info()

func show_interaction_prompt(text: String):
	interaction_prompt.text = text
	interaction_prompt.visible = true

func hide_interaction_prompt():
	interaction_prompt.visible = false
