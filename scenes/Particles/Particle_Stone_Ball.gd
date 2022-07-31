extends Node2D

var fragment_sprites = [
	preload("res://sprites/stone_fragment_1.png"), 
	preload("res://sprites/stone_fragment_2.png"), 
	preload("res://sprites/stone_fragment_3.png"), 
	preload("res://sprites/stone_fragment_4.png"), 
	preload("res://sprites/stone_fragment_5.png"), 
	preload("res://sprites/stone_fragment_6.png"), 
	preload("res://sprites/stone_fragment_7.png")]

var duration = 1
var elapsed

var fragments
var angles
var end_radii
var radii
var appearance_times
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
	end_radii = []
	appearance_times = []
	radii = []
	for i in range(60):
		var s = Sprite.new()
		s.texture = helpers.rand_choice(fragment_sprites)
		add_child(s)
		fragments.append(s)
		angles.append(rand_range(-PI, PI))
		var k = rand_range(0, 1)
		end_radii.append(25 - 25 * k * k)
		radii.append(rand_range(40, 50))
		appearance_times.append(rand_range(0, 0.4))
		s.visible = false
		
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	if elapsed < 0.6:
		progress = elapsed / 0.6
		position = start_pos + Vector2(0, -40 * progress)
		for i in range(60):
			if elapsed > appearance_times[i]:
				fragments[i].visible = true
			if fragments[i].visible:
				if radii[i] > end_radii[i]:
					radii[i] -= delta * 100
	else:
		progress = (elapsed - 0.6) / 0.4
		position = (start_pos + Vector2(0, -40)).linear_interpolate(end_pos, progress * progress)
	for i in range(60):
		fragments[i].position = Vector2(radii[i], 0).rotated(angles[i])
	if elapsed >= duration:
		queue_free()
