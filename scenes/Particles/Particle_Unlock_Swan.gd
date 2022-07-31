extends Node2D

var tendrils = []

func _ready():
	tendrils = []
	for i in range(3):
		var p = preload("res://scenes/Particles/Particle_Tendrils.tscn").instance()
		add_child(p)
		tendrils.append(p)

func half_speed():
	tendrils[2].queue_free()
	tendrils[1].queue_free()
