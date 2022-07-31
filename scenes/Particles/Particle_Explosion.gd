extends Node2D

var duration
var elapsed

var colour
var velocity
var alpha_mult
var size_mult

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass
	
func init(pos):
	position = pos + helpers.rand_in_circle(30)
	velocity = helpers.rand_in_circle(50)
	var b = randf()
	colour = Color(0.6 + b * 0.3, b * 0.8, b * 0.45)
	duration = 0.7 - 0.3 * b
	alpha_mult = 0.5 + 0.3 * b
	size_mult = 10 - 5 * b
	elapsed = 0
	
func _draw():
	var progress = elapsed / duration
	draw_circle(Vector2(0, 0), size_mult * (1 - progress) + 2, 
		Color(colour.r, colour.g, colour.b, alpha_mult * (1 - progress)))
	
func _process(delta):
	elapsed += delta
	update()
#	modulate.a = 1 - progress
	position += delta * velocity
	if elapsed >= duration:
		queue_free()
