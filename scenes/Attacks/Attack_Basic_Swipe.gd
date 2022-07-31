extends Node

var basic_attack = true
var fight

var duration = 0.9
var active_enemy
var target_birb
var damage

var elapsed
var path

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
	var a = rand_range(-PI, PI)
	path = [
		[Vector2(0, 0), 0, 0],
		[helpers.enemy_absolute_pos(helpers.default_birb_pos(target_birb), active_enemy) + Vector2(30, 0).rotated(a), 0.4, 50],
		[helpers.enemy_absolute_pos(helpers.default_birb_pos(target_birb), active_enemy) + Vector2(-60, 0).rotated(a), 0.5, 0],
		[Vector2(0, 0), 0.9, 50]
	]
	
func animate(delta):
	elapsed += delta

	fight.enemies[active_enemy].position = helpers.jump_path(path, elapsed)
	
	if helpers.this_frame(0.41, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/swipe_card-005.wav"))
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/flap_movement-002.wav"))
	
	if helpers.this_frame(0.45, elapsed, delta):
		fight.damage_birb(active_enemy, target_birb, damage)
		fight.start_screen_shake(25)
	
	return elapsed >= duration
