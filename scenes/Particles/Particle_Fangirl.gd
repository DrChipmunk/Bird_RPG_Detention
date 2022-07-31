extends Sprite

var duration = 1.8
var elapsed

var path
var sprites = [
	preload("res://sprites/fangirl_1_idle.png"), 
	preload("res://sprites/fangirl_2_idle.png"), 
	preload("res://sprites/fangirl_3_idle.png"), 
	preload("res://sprites/fangirl_4_idle.png"), 
	preload("res://sprites/fangirl_5_idle.png"), 
	preload("res://sprites/fangirl_6_idle.png"), 
	preload("res://sprites/fangirl_7_idle.png"), 
	preload("res://sprites/fangirl_8_idle.png"), 
	preload("res://sprites/fangirl_9_idle.png")
]

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos_enemy):
	elapsed = 0
	path = [
		[Vector2(rand_range(200, 400), 700), 0, 0],
		[Vector2(rand_range(300, 500), rand_range(50, 250)), 0.6, 50],
		[pos_enemy + Vector2(-50, 0), 1.2, 50],
		[Vector2(rand_range(200, 400), 700), 1.8, 50],		
	]
	position = path[0][0]
	texture = helpers.rand_choice(sprites)
	scale.x = -1
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = helpers.jump_path(path, elapsed)
	if elapsed >= duration:
		queue_free()
