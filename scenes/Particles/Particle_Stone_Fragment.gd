extends Sprite

var fragment_sprites = [
	preload("res://sprites/stone_fragment_1.png"), 
	preload("res://sprites/stone_fragment_2.png"), 
	preload("res://sprites/stone_fragment_3.png"), 
	preload("res://sprites/stone_fragment_4.png"), 
	preload("res://sprites/stone_fragment_5.png"), 
	preload("res://sprites/stone_fragment_6.png"), 
	preload("res://sprites/stone_fragment_7.png")]

var duration = 0.4
var elapsed

var velocity
var start_pos

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos):
	elapsed = 0
	start_pos = pos + Vector2(rand_range(-5, 5), 0)
	velocity = Vector2(rand_range(-250, 250), rand_range(-600, -100))
	position = start_pos
	texture = helpers.rand_choice(fragment_sprites)
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position += velocity * delta
	velocity += Vector2(0, 1000) * delta
	if elapsed >= duration:
		queue_free()
