extends Node2D

var countdown = 0.3
var freq = 0.3

func _ready():
	pass
	
func half_speed():
	freq = 0.7

func _process(delta):
	countdown -= delta
	if countdown < freq:
		countdown += freq
		for i in range(80):
			var p = preload("res://scenes/Particles/Particle_Meteor.tscn").instance()
			get_parent().add_child(p)
			p.position = position
