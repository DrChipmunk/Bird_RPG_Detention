extends Node2D

var a1 = 0
var a2 = 0
var timer = 0.1
var sidedness = false
var freq = 0.3
var num_dots = 12

func _ready():
	pass

func half_speed():
	num_dots = 8

func _process(delta):
	timer -= delta
	a1 += delta * 0.1
	a2 += delta * 0.107
	if timer < freq:
		timer += freq
		if sidedness:
			sidedness = false
			for i in range(num_dots - 1):
				var p = preload("res://scenes/Particles/Particle_Moire_Dot.tscn").instance()
				p.position = Vector2(600,0).rotated(a1 + i * 2 * PI / (num_dots - 1))
				add_child(p)
		else:
			sidedness = true
			for i in range(num_dots + 1):
				var p = preload("res://scenes/Particles/Particle_Moire_Dot.tscn").instance()
				p.position = Vector2(600,0).rotated(a2 + i * 2 * PI / (num_dots + 1))
				add_child(p)
