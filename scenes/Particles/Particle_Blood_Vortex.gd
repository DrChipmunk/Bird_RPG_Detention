extends Sprite

var duration = 0.5
var elapsed

var r
var angle
var start_pos

func _ready():
	pass

func init(pos):
	elapsed = 0
	angle = rand_range(-PI, PI)
	r = rand_range(50, 90)
	start_pos = pos
	position = pos + Vector2(r, 0).rotated(angle)
	
func _process(delta):
	elapsed += delta
	r = r * (1 - delta * 3)
	angle = angle + delta * 18
	position = start_pos + Vector2(r, 0).rotated(angle)
	if elapsed >= duration:
		queue_free()
