extends Sprite

var duration = 0.3
var elapsed
var init_pos
var end_pos

func _ready():
	pass

func init(pos):
	elapsed = 0
	position = pos
	init_pos = pos
	end_pos = Vector2(540, rand_range(0, 400))
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = init_pos.linear_interpolate(end_pos, progress)
	if elapsed >= duration:
		queue_free()
