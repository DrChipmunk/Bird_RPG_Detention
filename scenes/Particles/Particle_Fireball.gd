extends Node2D

var duration = 0.8
var elapsed

var pos1
var pos2

var colour
var size
var theta
var omega
var r

func _ready():
	pass
	
func init(_pos1, _pos2):
	position = _pos1
	pos1 = _pos1
	pos2 = _pos2
	colour = Color(rand_range(0.8, 1), rand_range(0.1, 0.2), rand_range(0, 0.1))
	size = rand_range(4, 9)
	theta = rand_range(-PI, PI)
	omega = rand_range(-15, 15)
	r = rand_range(0, 20)
	elapsed = 0
	
func _draw():
	draw_circle(Vector2(0, 0), size, colour)
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = pos1.linear_interpolate(pos2, progress * progress)
	position += Vector2(r, 0).rotated(theta)
	theta += omega * delta
	update()
	if randf() < 7 * delta:
		var p = preload("res://scenes/Particles/Particle_Flame.tscn").instance()
		p.init(position)
		get_parent().add_child(p)
	if elapsed >= duration:
		queue_free()
