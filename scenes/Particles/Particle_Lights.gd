extends Node2D

var duration = 2
var elapsed

var cyan
var yellow
var magenta
var angle

var fight
var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	fight = get_parent()
	pass
	
func init(pos1):
	position = pos1
	elapsed = 0
	cyan = get_child(0)
	yellow = get_child(1)
	magenta = get_child(2)
	angle = rand_range(-PI, PI)
	
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	var offset = 200 * (progress * 2 - 1)
	cyan.position = Vector2(offset, 0).rotated(PI * 2 / 3 + angle)
	yellow.position = Vector2(offset, 0).rotated(- PI * 2 / 3 + angle)
	magenta.position = Vector2(offset, 0).rotated(angle)
	angle += delta * 7
	
	if elapsed >= duration / 2:
		if fight.hand[0].type != fight.hand[1].type:
			queue_free()			
	if elapsed >= duration:
		queue_free()
