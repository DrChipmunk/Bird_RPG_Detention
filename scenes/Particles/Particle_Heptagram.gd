extends Node2D



var duration = 2
var elapsed

var deltas
var omegas
var stars
var vec1
var vec2

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos, _vec1, _vec2, texture):
	elapsed = 0
	position = pos
	vec1 = _vec1
	vec2 = _vec2
	deltas = []
	omegas = []
	for _i in range(7):
		deltas.append(rand_range(-PI, PI))
		omegas.append(rand_range(1, 2))
	stars = []
	for i in range(7):
		var line = []
		for j in range(7):
			var s = Sprite.new()
			s.texture = texture
			add_child(s)
			line.append(s)
			s.modulate.a = 0
		stars.append(line)
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	
	var portions = []
	var total = 0
	for i in range(7):
		var portion = 2 + sin(elapsed * omegas[i] + deltas[i])
		portions.append(portion)
		total += portion
	var base_angle = elapsed * 2
	var angles = []
	var acc = base_angle
	for i in range(7):
		angles.append(acc)
		acc += portions[i] * PI * 2 / total
	var corners = []
	for i in range(7):
		corners.append(vec1 * sin(angles[i]) + vec2 * cos(angles[i]))
	for i in range(7):
		var pos1 = corners[i]
		var pos2 = corners[(i + 3) % 7]
		for j in range(7):
			stars[i][j].position = pos1.linear_interpolate(pos2, j / 7.0)
			if progress < 0.1:
				stars[i][j].modulate.a = progress / 0.1
			elif progress > 0.9:
				stars[i][j].modulate.a = (progress - 0.9) / 0.1
			else:
				stars[i][j].modulate.a = 1
	if randf() < delta * 60:
		var k = helpers.rand_in_circle(1)
		k = k.x * vec1 + k.y * vec2
		
		var p = preload("res://scenes/Particles/Particle_Bone.tscn").instance()
		p.init(k + position)
		get_parent().add_child(p)

	if elapsed >= duration:
		queue_free()
