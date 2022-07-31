extends Node2D

var duration = 2
var elapsed = 0


var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass
	
func _process(delta):
	elapsed += delta
	get_node("S1").visible = true
	get_node("S2").visible = true
	var x = 0
	if elapsed < 0.5:
		var p = elapsed / 0.5
		x = 275 + (p - 1) * 12.5 - (1 - p) * (1 - p) * 462.5
	elif elapsed < 1.5:
		var p = (elapsed - 0.5) / 1
		x = 275 + p * 25
	else:
		var p = (elapsed - 1.5) / 0.5
		x = 300 + p * 12.5 + p * p * 487.5 
	get_node("S1").position = Vector2(700 - x,200)
	get_node("S2").position = Vector2(100 + x,200)
	if elapsed >= duration:
		queue_free()
