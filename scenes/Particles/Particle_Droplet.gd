extends Sprite

var squeam_sprites = [
	preload("res://sprites/squeam_1.png"), 
	preload("res://sprites/squeam_2.png")]

var duration = 0.4
var elapsed

var velocity
var start_pos

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos):
	elapsed = 0
	start_pos = pos + Vector2(rand_range(0, 70), 0).rotated(rand_range(-PI, PI))
	velocity = Vector2(rand_range(-250, 250), rand_range(-500, 0))
	position = start_pos
	texture = helpers.rand_choice(squeam_sprites)
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position += velocity * delta
	velocity += Vector2(0, 1000) * delta
	if elapsed >= duration:
		queue_free()
