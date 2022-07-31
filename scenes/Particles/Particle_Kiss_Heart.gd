extends Sprite

var duration = 1
var elapsed

var velocity
var start_pos

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos):
	elapsed = 0
	start_pos = pos + Vector2(rand_range(0, 40), 0).rotated(rand_range(-PI, PI))
	velocity = Vector2(0, -300) + Vector2(rand_range(0, 200), 0).rotated(rand_range(-PI, PI))
	position = start_pos
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = start_pos + velocity * progress
	velocity += delta * helpers.rand_in_circle(200)
	modulate.a = 1 - progress
	if elapsed >= duration:
		queue_free()
