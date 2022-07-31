extends Node2D

var duration = 0.75
var elapsed

var colour
var velocity

func _ready():
	pass
	
func init(pos, _colour):
	position = pos
	velocity = Vector2(rand_range(0, 200), 0).rotated(rand_range(-PI, PI))
	colour = _colour
	elapsed = 0
	
func _draw():
	var progress = elapsed / duration
	draw_circle(Vector2(0, 0), 5 * (1 - progress) + 2, colour)
	
func _process(delta):
	elapsed += delta
	update()
#	modulate.a = 1 - progress
	position += delta * velocity
	if elapsed >= duration:
		queue_free()
