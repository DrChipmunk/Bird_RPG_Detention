extends Sprite

var duration = 1
var elapsed = 0
var pos1

func _ready():
	pass

func init(pos):
	position = pos + Vector2(-300, 0)
	pos1 = pos
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = pos1 + Vector2(-300 * (progress * 2 - 1) * (progress * 2 - 1) * (progress * 2 - 1) * (progress * 2 - 1), 0)
	if elapsed >= duration:
		queue_free()
