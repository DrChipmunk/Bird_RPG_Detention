extends Node2D

var fragment_sprites = [
	preload("res://sprites/trash_particle_1.png"), 
	preload("res://sprites/trash_particle_2.png"), 
	preload("res://sprites/trash_particle_3.png"), 
	preload("res://sprites/trash_particle_4.png"), 
	preload("res://sprites/trash_particle_5.png"), 
]

var duration = 1
var elapsed

var fragments
var angles
var radii
var start_pos
var end_pos

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos1, pos2):
	elapsed = 0
	position = pos1
	start_pos = pos1
	end_pos = pos2
	fragments = []
	angles = []
	radii = []
	for i in range(20):
		var s = Sprite.new()
		s.texture = helpers.rand_choice(fragment_sprites)
		add_child(s)
		fragments.append(s)
		angles.append(rand_range(-PI, PI))
		radii.append(rand_range(0, 60))
		s.visible = true
		
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = helpers.jump_lerp(start_pos, end_pos, progress, 250)
	for i in range(20):		
		angles[i] += delta * rand_range(0, 5)
		fragments[i].position = Vector2(radii[i], 0).rotated(angles[i])
	if elapsed >= duration:
		queue_free()
