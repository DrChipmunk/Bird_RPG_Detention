extends Sprite

var duration = 1
var elapsed

var velocity
var start_pos

var sprites = [
	preload("res://sprites/bone_particle_1.png"), 
	preload("res://sprites/bone_particle_2.png"), 
	preload("res://sprites/bone_particle_3.png"), 
	preload("res://sprites/bone_particle_4.png"), 
	preload("res://sprites/bone_particle_5.png"), 
	preload("res://sprites/bone_particle_6.png"), 
	preload("res://sprites/bone_particle_7.png"), 
	preload("res://sprites/bone_particle_8.png"), 
	preload("res://sprites/bone_particle_9.png"), 
]

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos):
	elapsed = 0
	start_pos = pos + helpers.rand_in_circle(40)
	velocity = helpers.rand_in_circle(150)
	position = start_pos
	texture = helpers.rand_choice(sprites)
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = start_pos + velocity * progress
	velocity += delta * helpers.rand_in_circle(200)
	modulate.a = 1 - progress
	if elapsed >= duration:
		queue_free()
