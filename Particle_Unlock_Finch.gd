extends Node2D

var rays

func _ready():
	rays = []
	for i in range(20):
		var p = preload("res://scenes/Particles/Particle_God_Ray.tscn").instance()
		add_child(p)
		rays.append(p)
		

func half_speed():
	for i in range(10):
		rays[i].queue_free()
