extends Node

var resources: Dictionary = {
	"meteor_units": 0,
	"credits": 0
}

signal resource_updated(resource_name: String, new_value: int)

func add_resource(resource_name: String, amount: int) -> bool:
	if not resources.has(resource_name):
		return false
	resources[resource_name] += amount
	emit_signal("resource_updated", resource_name, resources[resource_name])
	return true

func get_resource(resource_name: String) -> int:
	return resources.get(resource_name, 0)
