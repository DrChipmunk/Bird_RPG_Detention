extends Node2D

var duration = 1
var elapsed

var positions

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos1, pos2):
	elapsed = 0
	positions = [pos1, pos1 + Vector2(rand_range(-150, 150), rand_range(-150, 150)), pos2]
	position = pos1
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = helpers.tween(positions, progress)
	if helpers.n_times_per_second(100, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Stone_Fragment.tscn").instance()
		p.init(position)
		get_parent().add_child(p)
	if elapsed >= duration:
		queue_free()
