extends Label

var velocity
var duration = 1.5
var elapsed

func _ready():
	elapsed = 0

func init(pos):
	rect_position += Vector2(pos.x + rand_range(-10, 10), pos.y + rand_range(-10, 10))
	velocity = Vector2(0, -40)
	
func _process(delta):
	rect_position += velocity * delta
	elapsed += delta
	modulate.a = 1 - (elapsed / duration)
	if elapsed >= duration:
		queue_free()
