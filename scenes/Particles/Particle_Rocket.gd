extends Sprite

var duration = 2
var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass
	
func init():
	position = Vector2(400, 200)
	elapsed = 0
	
func _process(delta):
	elapsed += delta
	
	var progress = elapsed / duration
	position = Vector2(400, 200 - 250 * pow(progress, 1.5))
	if helpers.n_times_per_second(40, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Smoke_Cloud.tscn").instance()
		p.init(position)
		get_parent().add_child(p)
	if elapsed >= duration:
		queue_free()
