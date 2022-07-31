extends Node2D

var duration = 1
var elapsed = 0

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos, spr):
	position = pos
	get_node("Sprite").texture = spr
	get_node("Sprite2").texture = spr
	get_node("Sprite3").texture = spr
	get_node("Sprite4").texture = spr
	
func _process(delta):
	elapsed += delta
	
	var k = 1 - elapsed
	var x = 30 * sin(6 * k)
	var y = 30 * sin(7.9 * k)
	
	get_node("Sprite").position = Vector2(x,y)
	get_node("Sprite2").position = Vector2(-x,y)
	get_node("Sprite3").position = Vector2(x,-y)
	get_node("Sprite4").position = Vector2(-x,-y)
	get_node("Sprite").self_modulate.a = elapsed * 0.5
	get_node("Sprite2").self_modulate.a = elapsed * 0.5
	get_node("Sprite3").self_modulate.a = elapsed * 0.5
	get_node("Sprite4").self_modulate.a = elapsed * 0.5
	
	if elapsed >= duration:
		queue_free()
