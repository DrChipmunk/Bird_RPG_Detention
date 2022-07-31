extends Node2D

var duration = 25.0 / 60.0
var elapsed = 0
var fight

var cards_moving

func _ready():
	fight = get_parent()

func resolve(active, target):
	elapsed = 0
	if len(fight.deck) == 0:
		while len(fight.discard) > 0:
			get_parent().add_child(preload("res://scenes/Particles/Particle_Shuffle.tscn").instance())
			var i = fight.rng.randi_range(0, len(fight.discard) - 1)
			var c = fight.discard[i]
			fight.discard.remove(i)
			fight.deck.append(c)
	var c = fight.deck.pop_back()
	c.visible = true
	c.position = Vector2(-100, 355)
	get_parent().add_child(preload("res://scenes/Particles/Particle_Deck_Out.tscn").instance())
	fight.hand.push_front(c)
	cards_moving = 7
	for i in range(len(fight.hand)):
		if !fight.hand[i]:
			cards_moving = i
			break
	if cards_moving == 7:
		c = fight.hand.pop_back()
		if c:
			fight.add_to_discard(c)
	else:
		fight.hand.remove(cards_moving)
	get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/draw_effect-002.wav"))

func animate(delta):
	elapsed += delta
	var progress = elapsed / duration
	for i in range(cards_moving):
		fight.hand[i].position -= Vector2(100.0 * (1 - progress) * (1 - progress), 0)
	return elapsed >= duration
