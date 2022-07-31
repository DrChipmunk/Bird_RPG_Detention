extends Sprite

var duration = 0.8
var elapsed
var init_pos
var end_pos

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos):
	elapsed = 0
	position = pos
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	if progress < 0.5:
		modulate.a = 1 - progress
	else:
		modulate.a = 1 - progress + 0.5
	if helpers.this_frame(0.4, elapsed, delta):
		texture = preload("res://sprites/hustle_particle_2.png")
	if elapsed >= duration:
		queue_free()
