extends Node2D

var duration = 1
var elapsed

var positions
var upgraded

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos, _upgraded):
	elapsed = 0
	upgraded = _upgraded
	position = pos
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	var offset
	if upgraded:
		offset = 50 - 50 * 4 * (progress - 0.5) * (progress - 0.5)
	else:
		offset = 50 - 50 * (1 - progress) * (1 - progress)
	get_node("Upper").modulate.a = 1 - progress * 0.9
	get_node("Upper").position = Vector2(0, -offset)
	get_node("Lower").modulate.a = 1 - progress * 0.9
	get_node("Lower").position = Vector2(0, offset)
	if elapsed >= duration:
		queue_free()
