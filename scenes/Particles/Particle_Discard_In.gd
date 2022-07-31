extends Sprite

var duration = 0.5
var elapsed

func _ready():
	position.x = 756
	position.y = 465
	modulate.a = 0
	elapsed = 0
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	modulate.a = progress
	position.x = 756
	position.y = 465 + progress * 50
	if elapsed >= duration:
		queue_free()
