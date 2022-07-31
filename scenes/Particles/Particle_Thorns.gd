extends Sprite

var duration = 1
var elapsed


var sprites = [
	preload("res://sprites/thorn_particle_1.png"), 
	preload("res://sprites/thorn_particle_2.png"), 
	preload("res://sprites/thorn_particle_3.png"), 
	preload("res://sprites/thorn_particle_4.png"), 
	preload("res://sprites/thorn_particle_5.png"), 
]
var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos):
	elapsed = 0
	position = pos
	texture = helpers.rand_choice(sprites)
	modulate.a = 0
	
func _process(delta):
	elapsed += delta
	if elapsed < 0.5:
		modulate.a = elapsed / 0.5
	else:
		modulate.a = (duration - elapsed) / 0.5
	if elapsed >= duration:
		queue_free()
