extends Node2D

var duration = 1.2
var elapsed

var is_enemy
var ypos
var line_xpos

var xpath

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass
	
func init(y, _is_enemy):
	ypos = y
	elapsed = 0
	is_enemy = _is_enemy
	position = Vector2(400, ypos)
	line_xpos = 0
	if not is_enemy:
		xpath = [
			Vector2(0, 0),
			Vector2(rand_range(-50, 50), 0),
			Vector2(rand_range(-100, -75), 0),		
			Vector2(100, 0),
		]
	else:
		xpath = [
			Vector2(0, 0),
			Vector2(rand_range(-50, 50), 0),
			Vector2(rand_range(75, 100), 0),		
			Vector2(-100, 0),
		]		
		get_child(0).texture = preload("res://sprites/death_arrow_right_bad.png")
		get_child(1).texture = preload("res://sprites/death_arrow_left_bad.png")
		
func _draw():
	draw_rect(Rect2(line_xpos, -15, 100 - line_xpos, 30), Color(1, 1, 1))
	draw_rect(Rect2(-100, -15, 100 + line_xpos, 30), Color(0, 0, 0))
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	line_xpos = helpers.tween(xpath, progress).x
	update()
	if helpers.n_times_per_second(30, elapsed, delta):
		for _i in range(6):
			var x = rand_range(-100, 100)
			var y = rand_range(-15, 15)
			var p = preload("res://scenes/Particles/Particle_Mote.tscn").instance()
			if x > line_xpos:
				p.init(Vector2(x + 400, y + ypos), Color(1, 1, 1))
			else:
				p.init(Vector2(x + 400, y + ypos), Color(0, 0, 0))
			get_parent().add_child(p)

				
	if elapsed >= duration:
		queue_free()
