extends Node2D

var duration = 0.1

var active_birb
var fight
var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	fight = get_parent()

func resolve(active, _target):
	elapsed = 0
	active_birb = active

func animate(delta):
	elapsed += delta
	if helpers.this_frame(0.05, elapsed, delta):
		if fight.hand[0].type == fight.hand[1].type:
			get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/lights_impact-001.wav"))
			for i in range(4):
				if i != active_birb:
					fight.heal_birb(i, 5)
	return elapsed >= duration
