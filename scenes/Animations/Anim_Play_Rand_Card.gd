extends Node2D

var duration = 1
var elapsed
var fight

var card

func _ready():
	fight = get_parent()

func resolve(active, target):
	elapsed = 0
	card = fight.random_available_card().instance()
	fight.add_child(card)
	card.visible = true
	card.position = Vector2(400 - 45, 200 - 95) + Vector2(800, 0).rotated(rand_range(-PI, PI)) 

func animate(delta):
	elapsed += delta
	card.position += delta * 4 * (Vector2(400 - 45, 200 - 95) - card.position)
	if elapsed >= duration:
		fight.play_card_random_target(card)
		card.visible = false
		return true
	return false
