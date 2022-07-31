extends Sprite

var duration = 1.2
var elapsed

var centre
var radius
var angle

var helpers = preload("res://scenes/Helpers.gd")

var sprites = [
	preload("res://sprites/relaxation_wisp_1.png"),
	preload("res://sprites/relaxation_wisp_2.png"),
	preload("res://sprites/relaxation_wisp_3.png"),
	preload("res://sprites/relaxation_wisp_4.png"),
	preload("res://sprites/relaxation_wisp_5.png"),
	preload("res://sprites/relaxation_wisp_6.png")
]

func _ready():
	pass

func init(pos1):
	elapsed = 0
	modulate.a = 0
	centre = pos1
	radius = sqrt(rand_range(400, 10000))
	angle = rand_range(-PI, PI)
	position = centre + Vector2(radius, 0).rotated(angle)
	texture = helpers.rand_choice(sprites)
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = centre + Vector2(radius, 0).rotated(angle)
	angle += delta * (100 / radius)
	if progress < 0.5:
		modulate.a = progress * 2
	else:
		modulate.a = 2 - 2 * progress
	if elapsed >= duration:
		queue_free()
