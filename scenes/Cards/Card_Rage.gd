extends Sprite

var type = "hawk"
var target_type = "none"
var card_name = "Rage"
var fight

var duration = 0.4
var active_birb
var elapsed

var target_enemy
var angle

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	elapsed = 0
	target_enemy = -1
	angle = 0
	
func animate(delta):
	elapsed += delta
	var progress = elapsed / duration
	
	if target_enemy == -1:
		var cards_in_hand = 0
		for i in range(7):
			if fight.hand[i]:
				cards_in_hand += 1
		if cards_in_hand == 0:
			return true
		var j = randi() % cards_in_hand
		var chosen_card = 0
		for i in range(7):
			if fight.hand[i]:
				if j == 0:
					chosen_card = i
					break
				j -= 1
		if fight.hand[chosen_card]:
			var c = fight.hand[chosen_card]
			fight.add_to_discard(c)
			fight.hand[chosen_card] = null
		target_enemy = fight.random_living_enemy()
		if target_enemy == -1:
			return true
		angle = rand_range(-PI, PI)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/rage_voice-005.wav"))
	
	fight.birbs[active_birb].position = helpers.birb_absolute_pos(helpers.default_enemy_pos(target_enemy) + Vector2(-100 + 200 * progress * progress, 0).rotated(angle), active_birb)
	
	if elapsed > 0.35:
		fight.damage_enemy(active_birb, target_enemy, 3)
		fight.start_screen_shake(10)
		elapsed = 0
		target_enemy = -1

	
	return elapsed >= duration
