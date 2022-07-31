extends Sprite

var duration = 0.5
var elapsed

func _ready():
	position.x = 706
	position.y = 515
	elapsed = 0
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	modulate.a = 1 - progress
	position.x = 706
	position.y = 515 - progress * 50
	if elapsed >= duration:
		queue_free()
