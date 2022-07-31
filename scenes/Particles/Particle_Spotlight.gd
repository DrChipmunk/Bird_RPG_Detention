extends Sprite

var duration = 1.5
var elapsed

var positions

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos1):
	elapsed = 0
	positions = [Vector2(400, 200) + helpers.rand_in_circle(200), 
		Vector2(400, 200) + helpers.rand_in_circle(200), 
		Vector2(400, 200) + helpers.rand_in_circle(200), 
		Vector2(400, 200) + helpers.rand_in_circle(200), 
		pos1]
	position = positions[0]
	
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = helpers.tween(positions, 1 - (1 - progress) * (1 - progress))
	if elapsed >= duration:
		queue_free()
