extends Sprite

var duration = 1
var elapsed

var end_r
var end_angle
var end_pos
var omega
var lock_time
var pulse_r
var pulse_m

func _ready():
	pass

func init(pos, a, b):
	elapsed = 0
	end_angle = (PI * 2 * a) / 9
	end_pos = pos
	end_r = b * 30 + 30
	lock_time = 0.7 - b * 0.1
	omega = rand_range(0.6, 1.5)
	pulse_m = rand_range(-70, 70)
	pulse_r = rand_range(1, 15)
	set_pos()

func set_pos():
	var a
	var r
	if elapsed > lock_time:
		a = end_angle
		r = end_r
	else:
		var delay = lock_time - elapsed
		a = end_angle + omega * delay
		r = end_r + pulse_m * sin(delay * pulse_r)
	position = end_pos + Vector2(r, 0).rotated(a)
	
func _process(delta):
	elapsed += delta
	set_pos()
	if elapsed >= duration:
		queue_free()
