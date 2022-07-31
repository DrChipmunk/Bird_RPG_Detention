extends Sprite

var type = "hawk"
var target_type = "enemy"
var card_name = "Big Pecks"
var fight
var consumable = true

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
	var start_pos = Vector2(0, 0)
	var end_pos = helpers.birb_absolute_pos(Vector2(470, 45 + 90 * target_enemy), active_birb)
	
	if elapsed < 0.4:
		var progress = elapsed / 0.4
		fight.birbs[active_birb].position = helpers.jump_lerp(start_pos, end_pos, progress, 50)
	elif elapsed < 0.6:
		fight.birbs[active_birb].position = end_pos
	else:
		var progress = (elapsed - 0.6) / 0.4
		fight.birbs[active_birb].position = helpers.jump_lerp(end_pos, start_pos, progress, 50)
	
	if helpers.this_frame(0.4, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/big_pecks_card-003.wav"))
		
	if helpers.this_frame(0.05, elapsed, delta) or helpers.this_frame(1.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/flap_movement-002.wav"))
		
	if helpers.this_frame(0.4, elapsed, delta):
		fight.birbs[active_birb].set_active_sprite(0.3)
		var p = preload("res://scenes/Particles/Particle_Peck.tscn").instance()
		p.init(480, 45 + 90 * target_enemy)
		fight.add_child(p)
	
	if helpers.this_frame(0.6, elapsed, delta):
		fight.damage_enemy(active_birb, target_enemy, 3)
		fight.birbs[active_birb].give_action()
		fight.add_suspended_card_front(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		fight.start_screen_shake(10)
	
	return elapsed >= duration
