extends Sprite

var fragment_sprites = [
	preload("res://sprites/stone_fragment_1.png"), 
	preload("res://sprites/stone_fragment_2.png"), 
	preload("res://sprites/stone_fragment_3.png"), 
	preload("res://sprites/stone_fragment_4.png"), 
	preload("res://sprites/stone_fragment_5.png"), 
	preload("res://sprites/stone_fragment_6.png"), 
	preload("res://sprites/stone_fragment_7.png")]

var duration = 0.3
var elapsed

var start_pos
var end_pos

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos, dur):
	elapsed = 0
	duration = dur + rand_range(0, 0.3)
	end_pos = pos
	start_pos = pos + helpers.rand_in_circle(150) + Vector2(0, 100)
	position = start_pos
	texture = helpers.rand_choice(fragment_sprites)
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / 0.4
	if progress > 1:
		progress = 1
	position = helpers.jump_lerp(start_pos, end_pos, progress, 25)
	if elapsed >= duration:
		queue_free()
