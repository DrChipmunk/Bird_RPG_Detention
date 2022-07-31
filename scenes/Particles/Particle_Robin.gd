extends Sprite

var duration = 0.3
var elapsed

var positions
var sprites = [
	preload("res://sprites/music_particle_1.png"), 
	preload("res://sprites/music_particle_2.png"), 
	preload("res://sprites/music_particle_3.png"), 
	preload("res://sprites/music_particle_4.png"), 
	preload("res://sprites/music_particle_5.png"), 
]

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos1, pos2):
	elapsed = 0
	positions = [pos1, pos1 + helpers.rand_in_circle(200), pos2]
	position = pos1
	texture = helpers.rand_choice(sprites)
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = helpers.tween(positions, progress)
	if elapsed >= duration:
		queue_free()
