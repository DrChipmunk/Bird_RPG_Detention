extends Node2D

var tendril_positions = []
var end_a = Vector2(0,0)
var end_v = Vector2(0,0)
var end_p = Vector2(0,0)
var sprites = []

func _ready():
	for i in range(30):
		tendril_positions.append(Vector2(0,0))
		var a = []
		for j in range(4):
			var s = Sprite.new()
			s.texture = preload("res://sprites/drain_orb.png")
			s.scale = Vector2(3 - i * 0.03,3 - i * 0.03)
			add_child(s)
			a.append(s)
		sprites.append(a)
	
func _process(delta):
	end_a += Vector2(rand_range(-10000,10000), rand_range(-10000,10000)) * delta
	end_a -= end_a * delta * 2
	end_v += end_a * delta
	end_v -= end_v * delta * 2
	end_p += end_v * delta
	if end_p.length() > 250:
		end_p -= end_p * delta * (end_p.length() - 250) * 0.003
	
	tendril_positions[29] = end_p
	for i in range(29):
		var dist = tendril_positions[29 - i].distance_to(tendril_positions[28 - i])
		if dist > 15:
			tendril_positions[28 - i] = tendril_positions[28 - i].move_toward(tendril_positions[29 - i], dist - 15)
	
	tendril_positions[0] = Vector2(0,0)
	for i in range(29):
		var dist = tendril_positions[i].distance_to(tendril_positions[i + 1])
		if dist > 15:
			tendril_positions[i + 1] = tendril_positions[i + 1].move_toward(tendril_positions[i], dist - 15)
	
	tendril_positions[29] = end_p
	for i in range(29):
		var dist = tendril_positions[29 - i].distance_to(tendril_positions[28 - i])
		if dist > 15:
			tendril_positions[28 - i] = tendril_positions[28 - i].move_toward(tendril_positions[29 - i], dist - 15)
	
	
	for i in range(30):
		sprites[i][0].position = tendril_positions[i]
		sprites[i][1].position = Vector2(-tendril_positions[i].x,tendril_positions[i].y)
		sprites[i][2].position = Vector2(tendril_positions[i].x,-tendril_positions[i].y)
		sprites[i][3].position = Vector2(-tendril_positions[i].x,-tendril_positions[i].y)
