extends CanvasLayer

@onready var player = null
@onready var meteor = null

func _physics_process(delta):
	if player and meteor:
		var distance = player.global_position.distance_to(meteor.global_position)
		$DistanceLabel.text = "Distance: %.1f m" % distance
