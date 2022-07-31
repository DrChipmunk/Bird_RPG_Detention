extends Sprite

var smoke_cloud_sprites = [
	preload("res://sprites/smoke_cloud_1.png"), 
	preload("res://sprites/smoke_cloud_2.png"), 
	preload("res://sprites/smoke_cloud_3.png"), 
	preload("res://sprites/smoke_cloud_4.png"), 
	preload("res://sprites/smoke_cloud_5.png"), 
	preload("res://sprites/smoke_cloud_6.png")]

var duration = 1
var elapsed

var velocity
var start_pos

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(pos):
	elapsed = 0
	start_pos = pos + Vector2(rand_range(0, 40), 0).rotated(rand_range(-PI, PI))
	velocity = Vector2(rand_range(0, 200), 0).rotated(rand_range(-PI, PI))
	position = start_pos
	texture = helpers.rand_choice(smoke_cloud_sprites)
	
func _process(delta):
	elapsed += delta
	var progress = elapsed / duration
	position = start_pos + velocity * progress
	modulate.a = 1 - progress
	if elapsed >= duration:
		queue_free()
