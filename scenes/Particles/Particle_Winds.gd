extends Sprite

var duration = 0.4
var elapsed

var positions

var tween_pos

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos1, pos2, pos3):
	elapsed = 0
	modulate.a = 0
	positions = [pos1 + helpers.rand_in_circle(50), pos2 + helpers.rand_in_circle(50), pos3 + helpers.rand_in_circle(50)]
	tween_pos = randf() * 0.5
	position = helpers.tween(positions, tween_pos)	
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = helpers.tween(positions, tween_pos + progress * 0.5)
	if progress < 0.5:
		modulate.a = progress * 2
	else:
		modulate.a = 2 - 2 * progress
	if elapsed >= duration:
		queue_free()
