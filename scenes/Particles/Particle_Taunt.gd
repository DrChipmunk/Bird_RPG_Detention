extends Sprite

var duration = 1.1
var elapsed
var init_pos
var end_pos

func _ready():
	pass

func init(pos):
	elapsed = 0
	position = pos
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	modulate.a = 1 - progress
	if elapsed >= duration:
		queue_free()
