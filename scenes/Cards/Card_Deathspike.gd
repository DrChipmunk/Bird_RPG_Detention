extends Sprite

var type = "swan"
var target_type = "enemy"
var card_name = "Deathspike"
var fight

var duration = 1.3
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
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/deathspike_card.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
		var p = preload("res://scenes/Particles/Particle_Deathspike.tscn").instance()
		p.init(helpers.default_enemy_pos(target_enemy).y, false)
		fight.add_child(p)
		
	if helpers.this_frame(1.25, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/explosion_long.wav"))
		fight.start_screen_shake(20)
		fight.enemies[target_enemy].max_hp -= 5
		if fight.enemies[target_enemy].max_hp < 1:
			fight.enemies[target_enemy].max_hp = 1
		if fight.enemies[target_enemy].hp > fight.enemies[target_enemy].max_hp:
			fight.enemies[target_enemy].hp = fight.enemies[target_enemy].max_hp
		fight.birbs[target_enemy].max_hp += 1
		
	
	return elapsed >= duration
