extends Node2D

var duration = 1
var elapsed = 0

func _ready():
	position = Vector2(800, 0)
	for i in range(8):
		for j in range(6):
			var t = Sprite.new()
			t.texture = preload("res://sprites/transition_tile.png")
			add_child(t)
			t.position = Vector2(i * 100, j * 100)
			t.centered = false

func _process(delta):
	elapsed += delta
	if elapsed < 0.5:
		var p = elapsed / 0.5
		p = p * p * 800
		position = Vector2(800 - p, 0)
	elif elapsed < duration:
		var p = (1 - elapsed) / 0.5
		p = p * p * 800
		position = Vector2(-800 + p, 0)
	else:
		queue_free()
