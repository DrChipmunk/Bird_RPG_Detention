extends Node2D

var duration = 1
var elapsed

var start_pos
var end_pos
var upgraded

var rotations
var radii
var sprites

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos1, pos2, _upgraded):
	elapsed = 0
	upgraded = _upgraded
	position = pos1
	start_pos = pos1
	end_pos = pos2
	rotations = [0, 0.1, 0.2]
	radii = [30, 40, 50]
	sprites = []
	for i in range(3):
		var r = []
		for j in range(5):
			var s = Sprite.new()
			s.texture = preload("res://sprites/nevermore_particle.png")
			s.position = spr_pos(i, j)
			add_child(s)
			r.append(s)
		sprites.append(r)

func spr_pos(i, j):
	return Vector2(radii[i], 0).rotated(rotations[i] + j * PI * 2 / 5)
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	if progress < 0.5:
		position = start_pos.linear_interpolate(end_pos, 4 * progress * progress)
		radii = [30, 40, 50]
	else:
		position = end_pos
		var k = 1 - progress
		k = k * k * 4
		k = 1 - k
		if upgraded:
			radii = [100 * k, 110 * k, 120 * k]
		else:
			radii = [50 * k, 55 * k, 60 * k]
	rotations[0] += delta * 5
	rotations[1] += delta * 5.5
	rotations[2] += delta * 6
	for i in range(3):
		for j in range(5):
			sprites[i][j].position = spr_pos(i, j)
		
	if elapsed >= duration:
		queue_free()
