extends Sprite

var duration = 0.25
var elapsed

var positions

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos1, pos2):
	elapsed = 0
	positions = [pos1 + helpers.rand_in_circle(10), (pos1 + pos2) / 2 + helpers.rand_in_circle(150), pos2 + helpers.rand_in_circle(10)]
	position = pos1
	
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = helpers.tween(positions, progress)

	if elapsed >= duration:
		queue_free()
