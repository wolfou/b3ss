extends CanvasLayer

func on_update_distance(distance):
	$DistanceLabel.text = "Distance: %.1f m" % distance
