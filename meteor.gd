extends RigidBody3D

@export var max_units: int = 5
var current_units: int = 5
var type = "Meteor"

func _ready():
	add_to_group("interactables")
