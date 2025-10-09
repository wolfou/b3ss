extends CanvasLayer

@export var spatial_relation: SpatialRelation
@onready var target_info = $TargetInfo
@onready var ship_info = $ShipInfo
var player: Node

func _ready():
	$ShipInfo.position = Vector2(1000, 20)
	$TargetInfo.position = Vector2(20, 20)

	if player:
		player.inventory.resource_updated.connect(_on_resource_updated)

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
	target_info.modulate = Color(0.5, 1, 0.5)


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
	ship_info.modulate = Color(0.5, 1, 0.5)

func _on_resource_updated(_resource_name: String, _new_value: int):
	update_ship_info()
