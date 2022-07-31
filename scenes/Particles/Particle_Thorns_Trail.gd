extends Node2D

var duration = 1.5
var elapsed

var centre

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos1):
	elapsed = 0
	centre = pos1
	position = pos1 + helpers.rand_in_circle(200)
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position += delta * helpers.rand_in_circle(1000)
	position += delta * (centre - position) * 1.5
	if helpers.n_times_per_second(40, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Thorns.tscn").instance()
		p.init(position)
		get_parent().add_child(p)
	if elapsed >= duration:
		queue_free()
