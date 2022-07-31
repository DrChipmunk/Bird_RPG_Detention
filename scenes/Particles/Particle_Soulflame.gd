extends Sprite

var duration = 0.3
var elapsed

var positions

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos1, pos2):
	elapsed = 0
	positions = [pos1, 
		pos1 + helpers.rand_in_circle(150), 
		(pos1 + pos2) / 2 + helpers.rand_in_circle(150), 
		pos2]
	position = pos1
	
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = helpers.tween(positions, progress)
	if helpers.n_times_per_second(12, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Mote.tscn").instance()
		p.init(position, Color(1, 1, 1))
		get_parent().add_child(p)
	if elapsed >= duration:
		queue_free()
