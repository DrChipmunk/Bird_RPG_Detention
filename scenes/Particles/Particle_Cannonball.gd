extends Sprite

var duration = 0.4
var elapsed

var start_pos
var end_pos

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos1, pos2):
	elapsed = 0
	start_pos = pos1
	end_pos = pos2
	position = pos1
	
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = helpers.jump_lerp(start_pos, end_pos, progress, 75)
	if elapsed >= duration:
		queue_free()
