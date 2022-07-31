extends Sprite

var duration = 1
var elapsed = 0

func _ready():
	pass

func init(pos):
	position = pos

func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	modulate.a = 1 - progress
	if elapsed >= duration:
		queue_free()
