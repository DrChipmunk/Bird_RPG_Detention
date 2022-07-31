extends Sprite

var duration = 1
var elapsed

var centre_pos
var parity

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(tex, pos1, b):
	elapsed = 0
	centre_pos = pos1
	position = pos1
	parity = b
	texture = tex
	modulate.a = 0.5
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	var a = (1 - cos(progress * PI * 2)) * 30
	var phi = progress * 25
	if parity:
		phi += PI
	position = centre_pos + Vector2(a, 0).rotated(phi)
	if elapsed >= duration:
		queue_free()
