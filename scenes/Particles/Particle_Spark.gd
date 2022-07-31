extends Sprite

var duration = 0.5
var elapsed

var end_pos
var velocity

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos1, direction):
	elapsed = 0
	position = pos1 + Vector2(rand_range(0, 20), 0).rotated(rand_range(-PI, PI))
	end_pos = position + Vector2(85, 0).rotated(direction)
	velocity = Vector2(0, 0)
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position += velocity
	velocity += Vector2(rand_range(0, 200), 0).rotated(rand_range(-PI, PI)) * delta
	velocity += (end_pos - position) * 0.5 * delta
	if elapsed >= duration:
		queue_free()
