extends Sprite

var duration = 1
var elapsed

var positions

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos1, pos2):
	elapsed = 0
	positions = [pos1, pos1 + Vector2(rand_range(-100, 100), rand_range(-100, 100)), pos2]
	position = pos1
	
func _process(delta):
	elapsed += delta
	if elapsed < 0.7:	
		var progress = 1 - (1 - elapsed / 0.7) * (1 - elapsed / 0.7)	
		position = helpers.jump_lerp(positions[0], positions[1], progress, 0)
	else:
		var progress = ((elapsed - 0.7) / 0.3) * ((elapsed - 0.7) / 0.3)
		position = helpers.jump_lerp(positions[1], positions[2], progress, 0)
	if elapsed >= duration:
		queue_free()
