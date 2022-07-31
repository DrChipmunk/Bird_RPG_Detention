extends Node2D

var idle_sprites = [
	preload("res://sprites/hawk_idle.png"), 
	preload("res://sprites/finch_idle_new.png"), 
	preload("res://sprites/peacock_idle.png"), 
	preload("res://sprites/swan_idle.png")]

var duration = 1
var elapsed

var sprite1
var sprite2

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(birb, pos):
	elapsed = 0
	position = pos
	sprite1 = Sprite.new()
	sprite1.texture = idle_sprites[birb]
	sprite1.modulate = Color(1, 1, 1, 0.5)
	add_child(sprite1)
	sprite2 = Sprite.new()
	sprite2.texture = idle_sprites[birb]
	sprite2.modulate = Color(1, 1, 1, 0.5)
	add_child(sprite2)	
		
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	var offset = 15 * (1 - cos(progress * 2 * PI))
	sprite1.position = Vector2(offset, offset)
	sprite2.position = Vector2(-offset, -offset)
	if elapsed >= duration:
		queue_free()
