extends Sprite


var duration = 1
var elapsed

var start_pos
var end_pos

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos):
	elapsed = 0
	end_pos = pos
	start_pos = pos + helpers.rand_in_circle(150) + Vector2(0, 100)
	position = start_pos
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	var k = 1
	if progress < 0.4:
		k = progress / 0.4
		k = k * k * k
	position = start_pos.linear_interpolate(end_pos, k)
	
	if elapsed >= duration:
		queue_free()
