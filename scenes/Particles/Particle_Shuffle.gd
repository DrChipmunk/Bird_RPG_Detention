extends Sprite

var duration = 0.3
var elapsed
var start_pos = Vector2(755, rand_range(515, 521))
var end_pos = Vector2(705, rand_range(515, 521))
var jump_height = rand_range(20, 40)
var delay = rand_range(0, 0.6)

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	position = start_pos
	visible = false
	elapsed = 0
	
func _process(delta):
	if delay > 0:
		delay -= delta
		if delay <= 0:
			visible = true
	else:
		elapsed += delta
		var progress = elapsed / duration
		position = helpers.jump_lerp(start_pos, end_pos, progress, jump_height)
		if elapsed >= duration:
			queue_free()
