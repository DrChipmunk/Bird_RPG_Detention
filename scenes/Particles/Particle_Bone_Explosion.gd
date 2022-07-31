extends Sprite

var duration = 1.6
var elapsed

var start_pos
var end_pos
var max_rad
var angle
var omega
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

func init(pos1, pos2):
	elapsed = 0
	start_pos = pos1
	end_pos = pos2
	angle = rand_range(-PI, PI)
	max_rad = rand_range(0, 200)
	omega = rand_range(2, 4)
	texture = helpers.rand_choice(sprites)
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	var rad = max_rad * (1 - (progress - 0.5) * (progress - 0.5) * 4)
	position = start_pos.linear_interpolate(end_pos, progress) + Vector2(rad, 0).rotated(angle)
	angle += omega * delta
	if elapsed >= duration:
		queue_free()
