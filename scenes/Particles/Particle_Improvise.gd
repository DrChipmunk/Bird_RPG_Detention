extends Sprite

var duration = 1
var elapsed

var velocity

var sprites = [
	preload("res://sprites/music_particle_1.png"), 
	preload("res://sprites/music_particle_2.png"), 
	preload("res://sprites/music_particle_3.png"), 
	preload("res://sprites/music_particle_4.png"), 
	preload("res://sprites/music_particle_5.png"), 
]

var helpers = preload("res://scenes/Helpers.gd")

var delay

func _ready():
	pass

func init(pos, angle):
	elapsed = 0
	velocity = Vector2(rand_range(200, 400), 0).rotated(angle)
	position = pos + Vector2(rand_range(0, 40), 0).rotated(angle)
	delay = rand_range(0, 1)
	modulate.a = 0
	texture = helpers.rand_choice(sprites)
	
func _process(delta):
	elapsed += delta
	if delay > elapsed:
		modulate.a = 0
		delay -= elapsed
		elapsed = 0
	else:
		delay = 0
		modulate.a = 1
		var progress = elapsed / duration
		position += velocity * delta
		velocity += delta * helpers.rand_in_circle(3000)
	if elapsed >= duration:
		queue_free()
