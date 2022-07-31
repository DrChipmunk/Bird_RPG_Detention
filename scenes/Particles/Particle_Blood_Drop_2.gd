extends Sprite

var duration = 0.5
var elapsed

var start_pos
var move

func _ready():
	elapsed = 0

func init(pos, _move):
	start_pos = pos
	position = pos
	move = _move 
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = start_pos + move * (1 - (1 - progress) * (1 - progress))
	modulate.a = 1 - progress
	if elapsed >= duration:
		queue_free()
