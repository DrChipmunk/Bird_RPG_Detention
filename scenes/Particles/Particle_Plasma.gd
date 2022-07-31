extends Node2D

var duration = 1
var elapsed

var orbs
var path
var helpers = preload("res://scenes/Helpers.gd")
var alpha
var beta

func _ready():
	pass
	
func init(pos1, pos2):
	position = pos1
	elapsed = 0
	orbs = [get_node("Cyan"), get_node("Magenta"), get_node("Yellow")]
	path = [pos1, (pos1 + pos2) / 2 + helpers.rand_in_circle(150), pos2]
	alpha = rand_range(-PI, PI)
	beta = rand_range(-PI, PI)
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration

	position = helpers.tween(path, progress)
	
	var vec1 = Vector2(50, 0).rotated(elapsed * 3 + alpha)
	var vec2 = vec1.rotated(PI / 2)
	for i in range(3):
		orbs[i].position = vec1 * sin(elapsed * 12 + i * PI * 4 / 3 + beta * 2) + vec2 * sin(elapsed * 6 + i * PI * 2 / 3 + beta)
	if helpers.n_times_per_second(10, elapsed, delta):
		for i in range(3):
			var p = preload("res://scenes/Particles/Particle_Shatter_Cross.tscn").instance()
			p.init(orbs[i].position + position)
			p.texture = orbs[i].texture
			get_parent().add_child(p)	

	if elapsed >= duration:
		queue_free()
