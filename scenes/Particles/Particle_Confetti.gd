extends Sprite

var left_sprites = [
	preload("res://sprites/confetti_1_a.png"), 
	preload("res://sprites/confetti_2_a.png"), 
	preload("res://sprites/confetti_3_a.png"), 
	preload("res://sprites/confetti_4_a.png")
]

var right_sprites = [
	preload("res://sprites/confetti_1_b.png"), 
	preload("res://sprites/confetti_2_b.png"), 
	preload("res://sprites/confetti_3_b.png"), 
	preload("res://sprites/confetti_4_b.png")
]

var duration = 0.5
var elapsed

var velocity
var colour
var side

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos):
	elapsed = 0
	duration = rand_range(0.5, 0.9)
	velocity = Vector2(0, -1000) + helpers.rand_in_circle(500)
	position = pos
	colour = randi() % 4
	if randi() % 2 == 0:
		side = true
	else:
		side = false
	confetti_texture()
	
func confetti_texture():
	if side:
		texture = left_sprites[colour]
	else:
		texture = right_sprites[colour]
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position += velocity * delta
	velocity += Vector2(0, 400) * delta
	velocity += velocity * delta * -10
	if randf() < delta * 3:
		side = not side
		confetti_texture()
	if elapsed >= duration:
		queue_free()
