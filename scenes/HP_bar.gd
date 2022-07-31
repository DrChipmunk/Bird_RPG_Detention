extends Node2D

var health_colour = Color(0.2, 0.8, 0.2)
var no_health_colour = Color(0.4, 0, 0)

var health_proportion = 0

func _ready():
	pass

func _process(delta):
	update()

func _draw():
	var hp_pix = int(195 * health_proportion)
	if hp_pix > 0:
		draw_rect(Rect2(7, 32, hp_pix, 16), health_colour)
	if hp_pix < 194:
		draw_rect(Rect2(7 + hp_pix, 32, 195 - hp_pix, 16), no_health_colour)
	pass
