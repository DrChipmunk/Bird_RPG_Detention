extends Node2D

var angle = 0
var angle_v = 0
var angle_a = 0
var width = 0.1
var width_v = 0
var width_a = 0
var hue = 0
var hue_v = 0
var hue_a = 0

func _draw():
	var points = [Vector2(0,0), Vector2(600,0).rotated(angle + width), Vector2(600,0).rotated(angle - width)]
	draw_colored_polygon(points, Color.from_hsv(hue, 1, 1))

func _ready():
	angle = rand_range(-PI, PI)
	width = rand_range(0.05,0.15)
	hue = rand_range(0,1)
	
func _process(delta):
	angle_a += rand_range(-1,1) * delta
	angle_a -= angle_a * delta * 2
	angle_v += angle_a * delta
	angle_v -= angle_v * delta * 2
	angle += angle_v
	
	width_a += rand_range(-0.5,0.5) * delta
	width_a -= width_a * delta * 2
	width_v += width_a * delta
	width_v -= width_v * delta * 2
	width += width_v
	width -= (width - 0.1) * delta * 10
	
	hue_a += rand_range(-0.5,0.5) * delta
	hue_a -= hue_a * delta * 3
	hue_v += hue_a * delta
	hue_v -= hue_v * delta * 3
	hue += hue_v
	if hue < 0:
		hue += 1
	if hue > 1:
		hue -= 1
		
	update()
