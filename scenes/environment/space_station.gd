extends Node3D

@export var angular_velocity: float = 0.14
var sun_direction: Vector3 = Vector3(0, 0, 0.7)

func _ready():
	orient_towards_sun()

func orient_towards_sun():
	sun_direction = sun_direction.normalized()
	var right = Vector3(1, 0, 0)
	if abs(sun_direction.dot(right)) > 0.99:
		right = Vector3(0, 1, 0)
	var x_axis = sun_direction.cross(right).normalized()
	var y_axis = sun_direction
	var z_axis = x_axis.cross(y_axis).normalized()
	transform.basis = Basis(x_axis, y_axis, z_axis)

func _process(delta: float) -> void:
	transform.basis *= Basis.from_euler(Vector3(0, angular_velocity * delta, 0))
