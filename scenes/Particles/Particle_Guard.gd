extends Sprite

var duration = 0.6
var elapsed = 0
var init_pos
var is_enemy

func _ready():
	pass

func init(pos, _is_enemy):
	position = pos
	init_pos = pos
	is_enemy = _is_enemy
	if is_enemy:
		scale.x = -1
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	modulate.a = 1 - progress
	if is_enemy:
		position = init_pos + Vector2(-25 * progress, 0)
	else:
		position = init_pos + Vector2(25 * progress, 0)
	if elapsed >= duration:
		queue_free()
