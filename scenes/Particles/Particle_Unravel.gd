extends Sprite

var duration = 1
var elapsed

var visible_time
var end_move_time
var start_pos
var end_pos

func _ready():
	pass

func init(pos, angle, radius, start_time):
	elapsed = 0
	start_pos = pos + Vector2(radius, 0).rotated(angle)
	end_pos = pos + Vector2(100 * 100 / radius, 0).rotated(angle)
	visible_time = start_time
	end_move_time = visible_time + 0.5
	
func _process(delta):
	elapsed += delta
	if elapsed < visible_time:
		modulate.a = elapsed / visible_time
	elif elapsed < end_move_time:
		modulate.a = 1
		var k =  (elapsed - visible_time) / 0.5
		position = start_pos * (1 - k * k) + end_pos * k * k
	else:
		modulate.a = (duration - elapsed) / (duration - end_move_time)
	if elapsed >= duration:
		queue_free()
