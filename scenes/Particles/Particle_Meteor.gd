extends Node2D

var fragment_sprites = [
	preload("res://sprites/stone_fragment_1.png"), 
	preload("res://sprites/stone_fragment_2.png"), 
	preload("res://sprites/stone_fragment_3.png"), 
	preload("res://sprites/stone_fragment_4.png"), 
	preload("res://sprites/stone_fragment_5.png"), 
	preload("res://sprites/stone_fragment_6.png"), 
	preload("res://sprites/stone_fragment_7.png")]
	
var velocity
var life = 1

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	
	get_node("Sprite").texture = helpers.rand_choice(fragment_sprites)
	get_node("Sprite").modulate = Color(rand_range(0.8,1),rand_range(0.3,0.5),rand_range(0.3,0.5))
	velocity = Vector2(rand_range(700,900),0).rotated(rand_range(-PI,PI))
	
func _process(delta):
	velocity -= velocity * delta * 0.5
	position += velocity * delta
	life -= delta
	if life < 0:
		queue_free()
