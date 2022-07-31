extends Sprite

var enemy

var hp_text
var hp_bar
var effect_nodes
var attack_intents

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	hp_text = get_node("HP_text")
	hp_bar = get_node("HP_bar")
	effect_nodes = [
		get_node("Effect_1"),
		get_node("Effect_2"),
		get_node("Effect_3"),
		get_node("Effect_4"),
		get_node("Effect_5")
	]
	attack_intents = [
		get_node("Attack_1"),
		get_node("Attack_2"),
		get_node("Attack_3"),
		get_node("Attack_4")
	]

func init(_enemy):
	enemy = _enemy

var basic_attack_sprites = [
	preload("res://sprites/intent_hawk_damage.png"),
	preload("res://sprites/intent_finch_damage.png"),
	preload("res://sprites/intent_peacock_damage.png"),
	preload("res://sprites/intent_swan_damage.png")
]

var effect_attack_sprites = [
	preload("res://sprites/intent_hawk_effect.png"),
	preload("res://sprites/intent_finch_effect.png"),
	preload("res://sprites/intent_peacock_effect.png"),
	preload("res://sprites/intent_swan_effect.png")
]
	
func _process(delta):
	if enemy.hp <= 0:
		visible = false
		return 
	visible = true
	hp_text.text = str(enemy.hp) + "/" + str(enemy.max_hp)
	hp_bar.health_proportion = float(enemy.hp) / enemy.max_hp
	if enemy.effects["defence"] > 0:
		hp_bar.health_colour = Color(0.4, 0.6, 0.8)
	else:
		hp_bar.health_colour = Color(0.2, 0.8, 0.2)
	for i in range(4):
		if len(enemy.attacks) > i:
			attack_intents[i].visible = true
			if enemy.attacks[i].basic_attack:
				attack_intents[i].texture = basic_attack_sprites[enemy.attacks[i].target_birb]
			else:
				attack_intents[i].texture = effect_attack_sprites[enemy.attacks[i].target_birb]
			attack_intents[i].get_node("Number").text = str(enemy.attacks[i].damage)
		else:
			attack_intents[i].visible = false
	var k = 0
	for effect in enemy.effects:
		if enemy.effects[effect] > 0:
			effect_nodes[k].visible = true
			effect_nodes[k].texture = helpers.effect_sprite(effect)
			effect_nodes[k].get_node("Number").text = str(enemy.effects[effect])
			k += 1
	while k < 5:
		effect_nodes[k].visible = false
		k += 1
