extends Sprite

var type = "finch_swan"
var target_type = "enemy"
var card_name = "Revenge"
var fight

var duration = 1
var active_birb
var target_enemy
var elapsed

var shots
var shots_fired

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	target_enemy = target
	elapsed = 0
	shots = fight.birbs[active_birb].max_hp - fight.birbs[active_birb].hp
	shots_fired = 0
	
func animate(delta):
	elapsed += delta
		
	if helpers.this_frame(0.05, elapsed, delta):
		if shots_fired == 0:
			get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/revenge_card.wav"))
			fight.birbs[active_birb].set_active_sprite(0.3)
		var p = preload("res://scenes/Particles/Particle_Revenge.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb), helpers.default_enemy_pos(target_enemy))
		fight.add_child(p)
		shots_fired += 1
		if shots_fired < shots:
			elapsed = 0
		
	if helpers.this_frame(0.95, elapsed, delta):
		fight.damage_enemy(active_birb, target_enemy, shots)
		fight.start_screen_shake(shots * 3)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/generic_impact-009.wav"))
		
	
	return elapsed >= duration
