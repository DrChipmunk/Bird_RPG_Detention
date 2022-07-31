extends Node2D

var duration = 1
var elapsed

var start_pos
var end_pos

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos1):
	elapsed = 0
	start_pos = pos1
	end_pos = pos1 + helpers.rand_in_circle(300)
	position = start_pos
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = start_pos.linear_interpolate(end_pos, 1 - (1 - progress) * (1 - progress))
	if helpers.n_times_per_second(40, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Radiance.tscn").instance()
		p.init(position)
		get_parent().add_child(p)
	if elapsed >= duration:
		queue_free()
