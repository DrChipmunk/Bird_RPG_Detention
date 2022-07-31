extends Sprite

var duration = 1
var elapsed

var velocity

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos):
	elapsed = 0
	modulate.a = 0
	var xo = rand_range(-100, 100)
	var yo = rand_range(-70, 30)
	if xo + yo < -70:
		xo += 100
		yo = -40 - yo
	if xo - yo > 70:
		xo -= 100
		yo = -40 - yo
	position = pos + Vector2(xo, yo)
	velocity = Vector2(rand_range(-50, 50), 0)
	
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position += velocity * delta
	if progress < 0.5:
		modulate.a = progress * 2
	else:
		modulate.a = 2 - 2 * progress
	if elapsed >= duration:
		queue_free()
