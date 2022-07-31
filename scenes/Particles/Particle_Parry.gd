extends Sprite

var duration = 0.8
var elapsed = 0
var init_pos

func _ready():
	pass

func init(pos):
	position = pos
	init_pos = pos
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	modulate.a = 1 - progress
	position = init_pos + Vector2(25 * progress, 0)
	if elapsed >= duration:
		queue_free()
