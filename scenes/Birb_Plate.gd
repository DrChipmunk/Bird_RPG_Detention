extends Sprite

var birb
var orbs
var hp_text
var hp_bar

var effect_nodes

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	orbs = []
	for i in range(4):
		orbs.append(get_child(i))
	hp_text = get_node("HP_text")
	hp_bar = get_node("HP_bar")
	effect_nodes = [
		get_node("Effect_1"),
		get_node("Effect_2"),
		get_node("Effect_3"),
		get_node("Effect_4"),
		get_node("Effect_5")
	]
	

func init(_birb):
	birb = _birb

func _process(delta):
	if birb.hp <= 0:
		visible = false
		return 
	visible = true
	for i in range(4):
		if i < birb.actions:
			orbs[i].visible = true
		else:
			orbs[i].visible = false
	hp_text.text = str(birb.hp) + "/" + str(birb.max_hp)
	hp_bar.health_proportion = float(birb.hp) / birb.max_hp
	if birb.effects["parrying"] > 0:
		hp_bar.health_colour = Color(0.8, 0.6, 0.4)
	elif birb.effects["immune"] > 0:
		hp_bar.health_colour = Color(1, 1, 0.4)
	elif birb.effects["defence"] > 0:
		hp_bar.health_colour = Color(0.4, 0.6, 0.8)
	else:
		hp_bar.health_colour = Color(0.2, 0.8, 0.2)
	var k = 0
	for effect in birb.effects:
		if birb.effects[effect] > 0:
			effect_nodes[k].visible = true
			effect_nodes[k].texture = helpers.effect_sprite(effect)
			effect_nodes[k].get_node("Number").text = str(birb.effects[effect])
			k += 1
	while k < 5:
		effect_nodes[k].visible = false
		k += 1
