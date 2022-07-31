extends Sprite

var duration = 0.5
var elapsed
var x_start
var y_start

func _ready():
	elapsed = 0
	
func init(x, y):
	x_start = x
	y_start = y
	position = Vector2(x_start, y_start)
	
func _process(delta):
	elapsed += delta
	
	var progress = elapsed / duration
	var k = progress * progress * progress * 50
	
	position = Vector2(x_start + k, y_start)
	
	if elapsed >= duration:
		queue_free()
