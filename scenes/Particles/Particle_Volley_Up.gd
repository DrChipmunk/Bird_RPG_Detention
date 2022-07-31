extends Sprite

var duration = 0.8
var elapsed = 0
var end_pos
var is_enemy

func _ready():
	pass

func init(pos, _is_enemy):
	is_enemy = _is_enemy
	end_pos = pos
	set_pos(0)
	
func set_pos(progress):
	var y_up = 400 - 400 * (1 - progress) * (1 - progress)
	var x_offset = 400 * progress
	if is_enemy:
		position = end_pos + Vector2(-x_offset, -y_up)
	else:
		position = end_pos + Vector2(x_offset, -y_up)
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	set_pos(progress)
	if elapsed >= duration:
		queue_free()
