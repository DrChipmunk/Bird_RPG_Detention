extends Sprite

var type = "hawk_swan"
var target_type = "enemy"
var card_name = "Terrify"
var fight

var duration = 1
var active_birb
var target_enemy
var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	target_enemy = target
	elapsed = 0
	
func animate(delta):
	elapsed += delta
	var progress = elapsed / duration
	var hexing = true
	for card in fight.hand:
		if card:
			hexing = false
			break
		
	if helpers.this_frame(0.05, elapsed, delta):
		fight.birbs[active_birb].set_active_sprite(0.2)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/terrify_card-004.wav"))
		var p = preload("res://scenes/Particles/Particle_Terrify.tscn").instance()
		p.init(helpers.default_enemy_pos(target_enemy), hexing)
		fight.add_child(p)					
		fight.damage_enemy(active_birb, target_enemy, 3)

	fight.enemies[target_enemy].position += Vector2(sin(progress * 25) * (5 - 20 * (progress - 0.5) * (progress - 0.5)), 0)
	
	if helpers.this_frame(0.95, elapsed, delta) and hexing:
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/generic_impact_hard-003.wav"))
		fight.enemies[target_enemy].increase_effect("weakened", 3)
		fight.start_screen_shake(10)		
	
	return elapsed >= duration
