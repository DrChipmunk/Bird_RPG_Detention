extends Node2D

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

var duration = 2
var elapsed

var bones
var angles
var radii
var appearance_times

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init():
	elapsed = 0
	position = Vector2(400, 200)
	bones = []
	angles = []
	appearance_times = []
	radii = []
	for i in range(100):
		var s = Sprite.new()
		s.texture = helpers.rand_choice(sprites)
		add_child(s)
		bones.append(s)
		angles.append(rand_range(-PI, PI))
		var k = rand_range(0, 1)
		radii.append(40 - 40 * k * k)
		appearance_times.append(rand_range(0, 0.4))
		s.visible = false
		
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	if elapsed < 1:
		for i in range(100):
			if elapsed > appearance_times[i]:
				bones[i].visible = true
				if elapsed > appearance_times[i] + 0.5:
					bones[i].position = Vector2(radii[i],0).rotated(angles[i])
				else:
					var m = (appearance_times[i] + 0.5 - elapsed) / 0.5
					bones[i].position = Vector2(radii[i] + 600 * m,0).rotated(angles[i] + 0.8 * m)
	else:
		progress = (elapsed - 1) / 1
		position = Vector2(400, 200 + 200 * progress * progress)
		for i in range(100):
			bones[i].position = Vector2(radii[i] * (1 + progress * 10),0).rotated(angles[i])
	if elapsed >= duration:
		queue_free()
