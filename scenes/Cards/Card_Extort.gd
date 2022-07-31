extends Sprite

var type = "swan"
var target_type = "enemy"
var card_name = "Extort"
var fight

var duration = 0.8
var active_birb
var target_enemy
var elapsed

var upgraded

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	target_enemy = target
	elapsed = 0
	var negative_effects = ["weakened", "shattered", "volley", "volley_imminent", "frozen", "quake", "thorns", "aflame"]
	upgraded = false
	for effect in negative_effects:
		if fight.enemies[target_enemy].effects[effect] > 0:
			upgraded = true
	
func animate(delta):
	elapsed += delta
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/drain_card-008.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
		
	if helpers.n_times_per_second(25, elapsed, delta):
		var p = preload("res://scenes/Particles/Particle_Drain.tscn").instance()
		if upgraded:
			p.init(helpers.default_enemy_pos(target_enemy), helpers.default_birb_pos(active_birb))
		else:
			p.init(helpers.default_enemy_pos(target_enemy), helpers.default_enemy_pos(target_enemy) + helpers.rand_in_circle(200))
		fight.add_child(p)
	
	if helpers.n_times_per_second(4, elapsed, delta):
		fight.start_screen_shake(7)
		
	if helpers.this_frame(0.75, elapsed, delta):
		fight.damage_enemy(active_birb, target_enemy, 4)
		if upgraded:
			fight.heal_birb(active_birb, 4)
		
		
	
	return elapsed >= duration
