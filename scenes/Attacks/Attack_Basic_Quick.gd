extends Node

var basic_attack = true
var fight

var duration = 0.5
var active_enemy
var target_birb
var damage

var elapsed
var a

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
	a = rand_range(-PI, PI)
	
func animate(delta):
	elapsed += delta

	if elapsed < 0.2:		
		fight.enemies[active_enemy].position = Vector2(0, 0)
		fight.enemies[active_enemy].modulate.a = (0.2 - elapsed) / 0.2
	elif elapsed < 0.3:
		fight.enemies[active_enemy].position = helpers.enemy_absolute_pos(helpers.default_birb_pos(target_birb), active_enemy)
		fight.enemies[active_enemy].position += Vector2((elapsed - 0.2) / 0.1 * 100 - 45, 0).rotated(a)
		fight.enemies[active_enemy].modulate.a = 1
	else:
		fight.enemies[active_enemy].position = Vector2(0, 0)
		fight.enemies[active_enemy].modulate.a = (elapsed - 0.3) / 0.2
	
	if helpers.this_frame(0.2, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/generic_swoosh-005.wav"))
		
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/flap_movement-002.wav"))
	
	if helpers.this_frame(0.25, elapsed, delta):
		fight.damage_birb(active_enemy, target_birb, damage)
		fight.start_screen_shake(15)
	
	return elapsed >= duration
