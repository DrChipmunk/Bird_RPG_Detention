extends Node2D

var duration = 0
var elapsed = 0
var fight

var cards_moving

func _ready():
	fight = get_parent()

func resolve(active, target):
	elapsed = 0
	var card = fight.hand[0]
	if !card:
		return
	fight.play_card_random_target(card)
	card.visible = false
	if !("consumable" in card):
		fight.add_to_discard(card)
	fight.hand[0] = null

func animate(delta):
	elapsed += delta
	return elapsed >= duration
