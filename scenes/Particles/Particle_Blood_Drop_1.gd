extends Sprite

var duration = 0.5
var elapsed

var start_pos
var is_enemy

func _ready():
	elapsed = 0

func init(pos, _is_enemy):
	start_pos = pos
	position = pos
	is_enemy = _is_enemy	
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	if not is_enemy:
		position = start_pos + Vector2(100 * (1 - (1 - progress) * (1 - progress)), 0)
	else:
		position = start_pos - Vector2(100 * (1 - (1 - progress) * (1 - progress)), 0)
	if elapsed >= duration:
		for _i in range(10):
			var p = preload("res://scenes/Particles/Particle_Blood_Drop_2.tscn").instance()
			p.init(position, Vector2(rand_range(-50, 50), rand_range(-300, 300)))
			get_parent().add_child(p)
		queue_free()
