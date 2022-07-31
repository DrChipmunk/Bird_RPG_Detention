extends Sprite

var duration = 0.6
var elapsed

var centre

var helpers = preload("res://scenes/Helpers.gd")

var sprites = [
	preload("res://sprites/math_particle_1.png"),
	preload("res://sprites/math_particle_2.png"),
	preload("res://sprites/math_particle_3.png"),
	preload("res://sprites/math_particle_4.png"),
	preload("res://sprites/math_particle_5.png"),
	preload("res://sprites/math_particle_6.png"),
	preload("res://sprites/math_particle_7.png"),
]

func _ready():
	pass

func init(pos1):
	elapsed = 0
	modulate.a = 0
	position = pos1 + helpers.rand_in_circle(80)
	centre = pos1
	texture = helpers.rand_choice(sprites)
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = centre + (position - centre) * (1 + delta)
	if progress < 0.5:
		modulate.a = progress * 2
	else:
		modulate.a = 2 - 2 * progress
	if elapsed >= duration:
		queue_free()
