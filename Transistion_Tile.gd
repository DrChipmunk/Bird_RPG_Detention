extends Sprite

var fade_time = 0
var start_time = 0
var start_time_1 = 0
var start_time_2 = 0
var up = false
var left = false
var x_offset = 0
var y_offset = 0
var rad = 0
var ang = 0
var omega = 0
var v = 0
var target_pos = Vector2(0, 0)
var pos1 = Vector2(0, 0)
var pos2 = Vector2(0, 0)
var vel = Vector2(0, 0)
var type = 0

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(t, pos):
	type = t
	target_pos = pos
	if type == 1:
		position = pos		
		visible = false
		fade_time = randf()
	elif type == 2:
		visible = false
		start_time = (float(pos.x) / 800) * 0.4 + 0.1 * randf()
	elif type == 3:
		visible = true
		position = Vector2(-1000, -1000)
	elif type == 4:
		visible = false
		start_time = (float(pos.x + pos.y) / 1400) * 0.6
	elif type == 5:
		visible = false
		up = int(pos.x / 100) % 2
		left = int(pos.y / 100) % 2  
		if up:      
			start_time_1 = (float(pos.y) / 600) * 0.5
		else:
			start_time_1 = (float(600 - pos.y) / 600) * 0.5
		if left:      
			start_time_2 = (float(pos.x) / 800) * 0.5
		else:
			start_time_2 = (float(800 - pos.x) / 800) * 0.5
	elif type == 6:
		visible = false
		start_time = rand_range(0, 0.5)
		x_offset = rand_range(-150, 150)
	elif type == 7:
		visible = false
		start_time = rand_range(0, 0.3)
		pos1 = Vector2(rand_range(-200,900), rand_range(-200,-100))
		pos2 = Vector2(rand_range(-200,900), rand_range(0,500))
	elif type == 8:
		visible = false
		start_time = (float(pos.x - pos.y + 500) / 1200) * 0.5
		vel = Vector2(400, 0).rotated(rand_range(-PI, PI))
	elif type == 9:
		visible = true
		vel = pos - Vector2(350,600)
	elif type == 10:
		visible = false
		fade_time = 1
		fade_time -= 0.5 * abs(350 - pos.x) / 350
		fade_time -= 0.5 * abs(500 - pos.y) / 500
		position = pos
	elif type == 11:
		visible = false
		start_time = (float(pos.y - pos.x + 700) / 1200) * 0.5
	elif type == 12:
		rad = pos.distance_to(Vector2(350, 250))
		ang = atan2((pos.y - 250), (pos.x - 350))
		omega = rand_range(1,2)
		v = rand_range(400,600)
		start_time = rad / 800
	elif type == 13:
		left = pos.x < 350
		up = pos.y < 250
		x_offset = abs(pos.x - 350)
		y_offset = abs(pos.y - 250)
		start_time = (float(600 - x_offset - y_offset) / 600) * 0.6
		
func in_anim(p):
	if type == 1:
		if p > fade_time and not visible:
			visible = true
	elif type == 2:
		if p > start_time and not visible:
			visible = true
		if p > start_time and p < start_time + 0.5:
			var k = (p - start_time) * 2
			k = (1 - k) * (1 - k) * 800
			position = target_pos + Vector2(k, 0)
		if p > start_time + 0.5:
			position = target_pos
	elif type == 3:
		var k = (1 - p * p) * 400
		if target_pos.x < 350:
			position = target_pos + Vector2(-k, 0)
		else:
			position = target_pos + Vector2(k, 0)
	elif type == 4:
		if p > start_time and not visible:
			visible = true
		if p > start_time and p < start_time + 0.4:
			var k = (p - start_time) / 0.4
			k = (1 - k) * (1 - k) * 300
			position = target_pos + Vector2(-k, -k)
		if p > start_time + 0.4:
			position = target_pos
	elif type == 5:
		if p > start_time_1 and not visible:
			visible = true
		if p > start_time_1 and p < start_time_1 + 0.5:
			var k = (p - start_time_1) * 2
			k = (1 - k) * (1 - k) * 600
			if up:
				position = target_pos + Vector2(0, k)
			else:
				position = target_pos + Vector2(0, -k)
		if p > start_time_1 + 0.5:
			position = target_pos
	elif type == 6:
		if p > start_time and not visible:
			visible = true
		if p > start_time and p < start_time + 0.5:
			var k = (p - start_time) * 2
			var z = (1 - k) * x_offset
			k = (1 - k) * (1 - k) * 600
			position = target_pos + Vector2(z, k)
		if p > start_time + 0.5:
			position = target_pos
	elif type == 7:
		if p > start_time and not visible:
			visible = true
		if p > start_time and p < start_time + 0.7:
			var positions = [pos1, pos2, target_pos]
			var k = (p - start_time) / 0.7
			k = 1 - (1 - k) * (1 - k)
			position = helpers.tween(positions, k)
		if p > start_time + 0.7:
			position = target_pos		
	elif type == 8:
		if p > start_time and not visible:
			visible = true
		if p > start_time and p < start_time + 0.5:
			var k = (p - start_time) * 2
			k = (1 - k) * (1 - k) * (1 - k)
			position = target_pos + k * vel
		if p > start_time + 0.5:
			position = target_pos
	elif type == 9:
		var k = -10 * p * (p - 1.1)
		position = Vector2(350,600) + k * vel
	elif type == 10:
		if p > fade_time and not visible:
			visible = true
	elif type == 11:
		if p > start_time and not visible:
			visible = true
		if p > start_time and p < start_time + 0.5:
			var k = (p - start_time) * 2
			var x = sin(k * 6) * (1 - k) * 100
			var y = -cos(k * 6) * (1 - k) * 200
			position = target_pos + Vector2(x,y)
		if p > start_time + 0.5:
			position = target_pos
	elif type == 12:
		if p > start_time and not visible:
			visible = true
		if p > start_time and p < start_time + 0.5:
			var k = (p - start_time) * 2
			var r = rad + (1 - k) * v
			var theta = ang + (1 - k) * omega
			position = Vector2(350,250) + Vector2(r,0).rotated(theta)
		if p > start_time + 0.5:
			position = target_pos
	elif type == 13:
		if p > start_time and not visible:
			visible = true
		if p > start_time and p < start_time + 0.4:
			var k = (p - start_time) / 0.4
			k = (1 - k) * (1 - k) * 200
			position = target_pos
			if left:
				position.x -= k
			else:
				position.x += k
			if up:
				position.y -= k
			else:
				position.y += k
		if p > start_time + 0.4:
			position = target_pos

func out_anim(p):
	if type == 1:
		if p > fade_time and visible:
			visible = false
	elif type == 2:
		if p < start_time:
			position = target_pos
		if p > start_time and p < start_time + 0.5:
			var k = (p - start_time) * 2
			k = k * k * 800
			position = target_pos + Vector2(-k, 0)
		if p > start_time + 0.5 and visible:
			visible = false
	elif type == 3:
		var k = (p * p) * 400
		if target_pos.x < 350:
			position = target_pos + Vector2(-k, 0)
		else:
			position = target_pos + Vector2(k, 0)
	elif type == 4:
		if p < 1 - start_time - 0.4:
			position = target_pos
		if p > 1 - start_time - 0.4 and p < 1 - start_time:
			var k = (p - (1 - start_time - 0.4)) / 0.4
			k = k * k * 300
			position = target_pos + Vector2(-k, -k)
		if p > 1 - start_time and visible:
			visible = false
	elif type == 5:
		if p < start_time_2:
			position = target_pos
		if p > start_time_2 and p < start_time_2 + 0.5:
			var k = (p - start_time_2) * 2
			k = k * k * 800
			if left:
				position = target_pos + Vector2(-k, 0)
			else:
				position = target_pos + Vector2(k, 0)
		if p > start_time_2 + 0.5 and visible:
			visible = false
	elif type == 6:
		if p < start_time:
			position = target_pos
		if p > start_time and p < start_time + 0.5:
			var k = (p - start_time) * 2
			var z = x_offset * k
			k = k * k * 600
			position = target_pos + Vector2(z, k)
		if p > start_time + 0.5 and visible:
			visible = false
	elif type == 7:
		if p < start_time:
			position = target_pos
		if p > start_time and p < start_time + 0.7:
			var positions = [target_pos, pos2, pos1]
			var k = (p - start_time) / 0.7
			k = k * k
			position = helpers.tween(positions, k)
		if p > start_time + 0.7 and visible:
			visible = false
	elif type == 8:
		if p < start_time:
			position = target_pos
		if p > start_time and p < start_time + 0.5:
			var k = (p - start_time) * 2
			k = k * k * k
			position = target_pos + k * vel
		if p > start_time + 0.5 and visible:
			visible = false
	elif type == 9:
		var k = 1 + (1 - (1 - p) * (1 - p)) * 6
		position = Vector2(350,600) + k * vel
	elif type == 10:
		if p > fade_time and visible:
			visible = false
	elif type == 11:
		if p < start_time:
			position = target_pos
		if p > start_time and p < start_time + 0.5:
			var k = (p - start_time) * 2
			var x = sin(6 * k) * k * 100
			var y = -cos(6 * k) * k * 200
			position = target_pos + Vector2(x,y)
		if p > start_time + 0.5 and visible:
			visible = false
	elif type == 12:
		if p < (1 - start_time - 0.5):
			position = target_pos
		if p > (1 - start_time - 0.5) and p < (1 - start_time):
			var k = (1 - start_time - p) * 2
			var r = rad + (1 - k) * v
			var theta = ang + (1 - k) * omega
			position = Vector2(350,250) + Vector2(r,0).rotated(theta)
		if p > (1 - start_time) and visible:
			visible = false
	elif type == 13:
		if p < (1 - start_time - 0.4):
			position = target_pos
		if p > (1 - start_time - 0.4) and p < (1 - start_time):
			var k = (p - (1 - start_time - 0.4)) / 0.4
			k = k * k * 300
			position = target_pos
			if left:
				position.x -= k
			else:
				position.x += k
			if up:
				position.y -= k
			else:
				position.y += k
		if p > start_time + 0.4 and visible:
			visible = false

func lock_pos():
	position = target_pos
	visible = true

