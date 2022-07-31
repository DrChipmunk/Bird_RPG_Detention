extends TextureRect

var size = Vector2(100, 100)

var velocity = Vector2(0, 0)
var acceleration = Vector2(0, 0)

func _ready():
	pass


func init(s):
	size = s
	margin_right = 800 + s.x
	margin_bottom = 400 + s.y
	

func _process(delta):
	acceleration += Vector2(rand_range(-0.6, 0.6), rand_range(-0.6, 0.6)) * delta
	acceleration -= acceleration * 0.6 * delta
	velocity += acceleration
	velocity -= velocity * 0.6 * delta
	rect_position += velocity
	if rect_position.x > 0:
		rect_position.x -= size.x
	if rect_position.x < -size.x:
		rect_position.x += size.x
	if rect_position.y > 0:
		rect_position.y -= size.y
	if rect_position.y < -size.y:
		rect_position.y += size.y
