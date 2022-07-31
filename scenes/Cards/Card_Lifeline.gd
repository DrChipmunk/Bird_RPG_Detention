extends Sprite

var type = "swan"
var target_type = "none"
var card_name = "Lifeline"
var fight

var duration = 1
var active_birb
var targets
var angles
var elapsed 

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func resolve(active, target):
	fight = get_parent()
	active_birb = active
	targets = []
	angles = []
	for i in range(4):
		if fight.birbs[i].hp <= 0:
			targets.append(i)
			angles.append(rand_range(-PI, PI))
	elapsed = 0
	
func animate(delta):
	elapsed += delta
	var progress = elapsed / duration
	
	
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/lifeline_card-004.wav"))
		fight.birbs[active_birb].set_active_sprite(0.3)
	
	for i in range(9):
		if helpers.this_frame(i * 0.1 + 0.05, elapsed, delta):	
			for k in range(len(targets)):
				for j in range(3):
					var p = preload("res://scenes/Particles/Particle_Lifeline.tscn").instance()
					p.init(helpers.default_birb_pos(targets[k]) + Vector2(i * 25 + 25, 0).rotated(angles[k] + j * PI * 2 / 3))
					fight.add_child(p)				

	
	if helpers.this_frame(0.95, elapsed, delta):
		for i in range(4):
			if fight.birbs[i].hp <= 0:
				fight.birbs[i].hp = 3
				fight.birbs[active_birb].max_hp -= 3
				fight.birbs[i].actions = 1
		for i in range(4):
			if fight.birbs[i].max_hp < 1:
				fight.birbs[i].max_hp = 1
			if fight.birbs[i].hp > fight.birbs[i].max_hp:
				fight.birbs[i].hp = fight.birbs[i].max_hp
		if len(targets) > 0:
			get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/explosion_long.wav"))
			fight.start_screen_shake(20)
		
	
	return elapsed >= duration
