extends Node

var basic_attack = true
var fight

var duration = 1.5
var active_enemy
var target_birb
var damage

var elapsed

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	pass

func init(active, target, amount):
	active_enemy = active
	target_birb = target
	damage = amount
	
func resolve(active, target):
	fight = get_parent()
	elapsed = 0
	
func animate(delta):
	elapsed += delta
	var start_pos = Vector2(0, 0)
	var end_pos = helpers.enemy_absolute_pos(helpers.default_birb_pos(target_birb) + Vector2(70, 0), active_enemy)
	
	if elapsed < 0.5:
		var progress = elapsed / 0.5
		fight.enemies[active_enemy].position = helpers.jump_lerp(start_pos, end_pos, progress, 50)
	elif elapsed < 1:
		fight.enemies[active_enemy].position = end_pos
	else:
		var progress = (elapsed - 1) / 0.5
		fight.enemies[active_enemy].position = helpers.jump_lerp(end_pos, start_pos, progress, 50)
	
	if helpers.this_frame(0.75, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/peck_card-003.wav"))
		
	if helpers.this_frame(0.05, elapsed, delta) or helpers.this_frame(1.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/flap_movement-002.wav"))
	
	if helpers.this_frame(1, elapsed, delta):
		fight.damage_birb(active_enemy, target_birb, damage)
		fight.start_screen_shake(3 * damage)
	
	return elapsed >= duration
