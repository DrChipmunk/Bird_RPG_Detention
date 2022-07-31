extends Sprite

var life = 5

func _ready():
	pass

func _process(delta):
	position -= position * delta * 0.6
	scale -= scale * delta * 0.6
	life -= delta
	if life < 0:
		queue_free()
