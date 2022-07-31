extends Node2D

var duration = 1
var elapsed

var hex_left
var hex_right

func _ready():
	pass
	
func init(pos1):
	position = pos1
	elapsed = 0
	hex_left = get_child(0)
	hex_right = get_child(1)
	
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	var offset = 50 * (1 - progress) * (1 - progress)
	hex_left.position = Vector2(-offset, 0)
	hex_right.position = Vector2(offset, 0)
	if elapsed >= duration:
		queue_free()
