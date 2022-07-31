extends Sprite

var type = "swan"
var target_type = "enemy"
var card_name = "Nevermore"
var fight

var duration = 0.8
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
	var upgraded =  fight.birbs[active_birb].hp < 5
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/smoke_fade-003.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
		var p = preload("res://scenes/Particles/Particle_Nevermore.tscn").instance()
		p.init(helpers.default_birb_pos(active_birb), helpers.default_enemy_pos(target_enemy), upgraded)
		fight.add_child(p)
		
	if helpers.this_frame(0.55, elapsed, delta):
		fight.damage_enemy(active_birb, target_enemy, 5)
		fight.start_screen_shake(10)
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/nevermore_impact-003.wav"))
		
	if helpers.this_frame(0.75, elapsed, delta) and upgraded:
		fight.damage_enemy(active_birb, target_enemy + 1, 5)
		fight.damage_enemy(active_birb, target_enemy - 1, 5)
		
	
	return elapsed >= duration
