extends Sprite

var duration = 1
var elapsed


var sprites = [
	preload("res://sprites/freeze_particle_1.png"), 
	preload("res://sprites/freeze_particle_2.png"), 
	preload("res://sprites/freeze_particle_3.png"), 
	preload("res://sprites/freeze_particle_4.png"), 
	preload("res://sprites/freeze_particle_5.png"), 
]
var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos):
	elapsed = 0
	position = pos + helpers.rand_in_circle(75)
	texture = helpers.rand_choice(sprites)
	modulate.a = 0
	
func _process(delta):
	elapsed += delta
	if elapsed < 0.25:
		modulate.a = elapsed / 0.25
	elif elapsed < 0.75:
		modulate.a = 1
	else:
		modulate.a = (duration - elapsed) / 0.25
	if elapsed >= duration:
		queue_free()
