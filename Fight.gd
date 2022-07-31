extends Node2D

var hand
var deck
var discard
var state
var scene
var choices
var selected_card
var selected_birb
var suspended_cards
var curr_animation
var num_enemies
var turn_count
var soulflame_count
var times_rewinded

var birb_plates
var enemy_plates
var birbs
var enemies

var idle_timer

var rng
onready var sound_effect_player = get_node("Sound_Effect_Player")

var helpers = preload("res://scenes/Helpers.gd")

var effects = ["rage", "quick", "hype", "kissed", 
	"immune", "immune_imminent", "defence", "parrying",
	"shattered", "shattered_imminent", "frozen", "frozen_delayed", "thorns",
	"weakened", "bloodthirsty", "confused",
	"volley", "volley_imminent", "aflame", "regenerating", "quake", "fortified",
	"hustle", "hustle_delayed", "stun", "prepared"]

enum {STATE_START_OF_TURN,
	STATE_REGAIN_ACTIONS,
	STATE_DRAW_FOR_TURN,
	STATE_DAMAGE_TICKS,
	STATE_ENEMY_STRATEGY,
	STATE_CHOICE,
	STATE_SELECT_BIRB,
	STATE_SELECT_TARGET,
	STATE_END_OF_TURN,
	STATE_FORTIFY_TICK,
	STATE_ENEMY_ATTACKS,
	STATE_EFFECT_DECAY,
	STATE_REGENERATE}

var available_cards = [
	preload("res://scenes/Cards/Card_Aegis.tscn"),
	preload("res://scenes/Cards/Card_Assist.tscn"),
	preload("res://scenes/Cards/Card_Blood_Rite.tscn"),
	preload("res://scenes/Cards/Card_Bodyslam.tscn"),
	preload("res://scenes/Cards/Card_Channel.tscn"),
	preload("res://scenes/Cards/Card_Claw.tscn"),
	preload("res://scenes/Cards/Card_Cringe.tscn"),
	preload("res://scenes/Cards/Card_Deathspike.tscn"),
	preload("res://scenes/Cards/Card_Doomsday.tscn"),
	preload("res://scenes/Cards/Card_Extort.tscn"),
	preload("res://scenes/Cards/Card_Fangs.tscn"),
	preload("res://scenes/Cards/Card_Fires.tscn"),
	preload("res://scenes/Cards/Card_Focus.tscn"),
	preload("res://scenes/Cards/Card_Fortify.tscn"),
	preload("res://scenes/Cards/Card_Freeze.tscn"),
	preload("res://scenes/Cards/Card_Gains.tscn"),
	preload("res://scenes/Cards/Card_Guard.tscn"),
	preload("res://scenes/Cards/Card_Headcrack.tscn"),
	preload("res://scenes/Cards/Card_Heroics.tscn"),
	preload("res://scenes/Cards/Card_Hex.tscn"),
	preload("res://scenes/Cards/Card_Hustle.tscn"),
	preload("res://scenes/Cards/Card_Improvise.tscn"),
	preload("res://scenes/Cards/Card_Kneecap.tscn"),
	preload("res://scenes/Cards/Card_Lifeline.tscn"),
	preload("res://scenes/Cards/Card_Lights.tscn"),
	preload("res://scenes/Cards/Card_Missile.tscn"),
	preload("res://scenes/Cards/Card_Mists.tscn"),
	preload("res://scenes/Cards/Card_Nevermore.tscn"),
	preload("res://scenes/Cards/Card_Panic.tscn"),
	preload("res://scenes/Cards/Card_Parry.tscn"),
	preload("res://scenes/Cards/Card_Peck.tscn"),
	preload("res://scenes/Cards/Card_Prepare.tscn"),
	preload("res://scenes/Cards/Card_Purify.tscn"),
	preload("res://scenes/Cards/Card_Quake.tscn"),
	preload("res://scenes/Cards/Card_Radiance.tscn"),
	preload("res://scenes/Cards/Card_Rage.tscn"),
	preload("res://scenes/Cards/Card_Revenge.tscn"),
	preload("res://scenes/Cards/Card_Sass.tscn"),
	preload("res://scenes/Cards/Card_Savant.tscn"),
	preload("res://scenes/Cards/Card_Self_Care.tscn"),
	preload("res://scenes/Cards/Card_Solo.tscn"),
	preload("res://scenes/Cards/Card_Soulflame.tscn"),
	preload("res://scenes/Cards/Card_Spark.tscn"),
	preload("res://scenes/Cards/Card_Spotlight.tscn"),
	preload("res://scenes/Cards/Card_Shield.tscn"),
	preload("res://scenes/Cards/Card_Swipe.tscn"),
	preload("res://scenes/Cards/Card_Terrify.tscn"),
	preload("res://scenes/Cards/Card_Thorns.tscn"),
	preload("res://scenes/Cards/Card_Unravel.tscn"),
	preload("res://scenes/Cards/Card_Volley.tscn"),
	preload("res://scenes/Cards/Card_Winds.tscn"),
	preload("res://scenes/Cards/Card_Yell.tscn")
]

func random_available_card():
	return helpers.rand_choice(available_cards)

#Enemy Attacks:
# New Animations: Bone Summon, Duplicate summon


# Systems roadmap
# Enemy AI
# Dialogue
# Tutorial
# Deck Mode
# Talk Mode
# Transitions
# Pause menu and saving

func _ready():
	pass

#	var peck = preload("res://scenes/Cards/Card_Cringe.tscn").instance()
#	add_child(peck)
#	deck.append(peck)
#	peck.visible = false



func start_fight(_scene, _choices):
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	birbs = []
	birbs.append(get_node("Hawk"))
	birbs.append(get_node("Finch"))
	birbs.append(get_node("Peacock"))
	birbs.append(get_node("Swan"))	
	enemies = []
	enemies.append(get_node("Enemy_1"))
	enemies.append(get_node("Enemy_2"))
	enemies.append(get_node("Enemy_3"))
	enemies.append(get_node("Enemy_4"))
	get_node("Hawk_Plate").init(birbs[0])
	get_node("Finch_Plate").init(birbs[1])
	get_node("Peacock_Plate").init(birbs[2])
	get_node("Swan_Plate").init(birbs[3])
	birb_plates = []
	birb_plates.append(get_node("Hawk_Plate"))
	birb_plates.append(get_node("Finch_Plate"))
	birb_plates.append(get_node("Peacock_Plate"))
	birb_plates.append(get_node("Swan_Plate"))
	get_node("Enemy_Plate_1").init(enemies[0])
	get_node("Enemy_Plate_2").init(enemies[1])
	get_node("Enemy_Plate_3").init(enemies[2])
	get_node("Enemy_Plate_4").init(enemies[3])
	enemy_plates = []
	enemy_plates.append(get_node("Enemy_Plate_1"))
	enemy_plates.append(get_node("Enemy_Plate_2"))
	enemy_plates.append(get_node("Enemy_Plate_3"))
	enemy_plates.append(get_node("Enemy_Plate_4"))
	
	scene = _scene
	choices = _choices
	hand = []
	deck = []
	for _i in range(7):
		hand.append(null)
	discard = []
	state = STATE_START_OF_TURN
	suspended_cards = []
	selected_card = -1
	selected_birb = -1
	curr_animation = null 
	turn_count = 0
	soulflame_count = 1	
	idle_timer = 0
	var enemy_max_hp = [0, 0, 0, 0]
	for i in range(4):
		birbs[i].init(i)	

	if scene == "tutorial_1":
		get_node("Background").texture = preload("res://sprites/background_classroom.png")
		enemy_max_hp = [30, 30, 1, 1]
		enemies[0].texture = preload("res://sprites/ground_dove_idle.png")
		enemies[1].texture = preload("res://sprites/rock_pidgeon_idle.png")
		birbs[2].hp = 0
		birbs[3].hp = 0
		var p = preload("res://scenes/Particles/Particle_Tutorial_1_Highlight.tscn").instance()
		add_child(p)
	if scene == "tutorial_2":
		get_node("Background").texture = preload("res://sprites/background_museum_interior_day.png")
		enemy_max_hp = [24, 4, 1, 1]
		enemies[0].texture = preload("res://sprites/magpie_idle.png")
		enemies[1].texture = preload("res://sprites/magpie_idle.png")		
		times_rewinded = 0
		var p = preload("res://scenes/Particles/Particle_Tutorial_2_Highlight.tscn").instance()
		add_child(p)
	if scene == "magpie":
		get_node("Background").texture = preload("res://sprites/background_alleyway_v2.png")
		enemy_max_hp = [40, 40, 40, 1]
		enemies[0].texture = preload("res://sprites/magpie_idle.png")
		enemies[1].texture = preload("res://sprites/bluejay_idle.png")
		enemies[2].texture = preload("res://sprites/goose_bag_idle.png")
	if scene == "jocks":
		get_node("Background").texture = preload("res://sprites/background_track_v1.png")
		enemy_max_hp = [35, 28, 28, 28]
		enemies[0].texture = preload("res://sprites/eagle_idle.png")
		enemies[1].texture = preload("res://sprites/caracara_idle.png")
		enemies[2].texture = preload("res://sprites/vulture_idle.png")		
		enemies[3].texture = preload("res://sprites/falcon_idle.png")	
	if scene == "fangirls":
		get_node("Background").texture = preload("res://sprites/background_crowd_v1.png")
		enemy_max_hp = [7, 7, 7, 64]
		enemies[0].texture = preload("res://sprites/fangirl_1_idle.png")
		enemies[1].texture = preload("res://sprites/fangirl_2_idle.png")
		enemies[2].texture = preload("res://sprites/fangirl_3_idle.png")		
		enemies[3].texture = preload("res://sprites/ball_of_fangirls_idle.png")	
	if scene == "peep":
		get_node("Background").texture = preload("res://sprites/background_stage_v1.png")
		enemy_max_hp = [35, 35, 35, 35]
		enemies[0].texture = preload("res://sprites/robin_idle.png")
		enemies[1].texture = preload("res://sprites/blue_chickadee_idle.png")
		enemies[2].texture = preload("res://sprites/starling_idle.png")		
		enemies[3].texture = preload("res://sprites/warbler_idle.png")	
	if scene == "pidgeons":
		get_node("Background").texture = preload("res://sprites/background_alleyway_night_v2.png")
		enemy_max_hp = [40, 30, 40, 1]
		enemies[0].texture = preload("res://sprites/ground_dove_idle.png")
		enemies[1].texture = preload("res://sprites/jacobin_idle.png")
		enemies[2].texture = preload("res://sprites/rock_pidgeon_idle.png")		
	if scene == "goose":
		get_node("Background").texture = preload("res://sprites/background_behind_bar.png")
		enemy_max_hp = [40, 1, 1, 1]
		enemies[0].texture = preload("res://sprites/goose_idle.png")
		birbs[3].hp = 0
		if choices["pairing"] == "ry":
			birbs[2].hp = 0
		elif choices["pairing"] == "rg":
			birbs[1].hp = 0
		elif choices["pairing"] == "yg":
			birbs[0].hp = 0
	if scene == "duck":
		get_node("Background").texture = preload("res://sprites/background_front_bar.png")
		enemy_max_hp = [40, 1, 1, 1]
		enemies[0].texture = preload("res://sprites/duck_idle.png")
		if choices["pairing"] == "ry":
			birbs[0].hp = 0
			birbs[1].hp = 0
		elif choices["pairing"] == "rg":
			birbs[0].hp = 0
			birbs[2].hp = 0
		elif choices["pairing"] == "yg":
			birbs[1].hp = 0
			birbs[2].hp = 0
	if scene == "swanmother":
		get_node("Background").texture = preload("res://sprites/background_lucky_duck.png")
		enemy_max_hp = [40, 50, 40, 1]
		enemies[0].texture = preload("res://sprites/duck_idle.png")
		enemies[1].texture = preload("res://sprites/white_swan_idle.png")
		enemies[2].texture = preload("res://sprites/goose_idle.png")		
	if scene == "chickens":
		get_node("Background").texture = preload("res://sprites/background_museum_exterior.png")
		enemy_max_hp = [48, 36, 36, 36]
		enemies[0].texture = preload("res://sprites/quail_idle.png")
		enemies[1].texture = preload("res://sprites/chicken_stone_idle.png")
		enemies[2].texture = preload("res://sprites/chicken_plasma_idle.png")	
		enemies[3].texture = preload("res://sprites/chicken_ice_idle.png")	
	if scene == "pheasant":
		get_node("Background").texture = preload("res://sprites/background_museum_interior.png")
		enemy_max_hp = [81, 9, 1, 1]
		enemies[0].texture = preload("res://sprites/pheasant_idle.png")
		enemies[1].texture = preload("res://sprites/chicken_stone_idle.png")

	for i in range(4):
		enemies[i].init(enemy_max_hp[i])
		if enemy_max_hp[i] == 1:
			enemies[i].hp = 0
		if scene == "swanmother" and (i == 0 or i == 2):
			enemies[i].hp -= 5
		if scene == "pheasant" and i == 1:
			enemies[i].hp = 0
			enemies[i].self_modulate.a = 0
		if scene == "tutorial_2" and i == 1:
			enemies[i].hp = 0

	for _i in range(30):
		var peck = available_cards[rng.randi_range(0, len(available_cards) - 1)].instance()
		add_child(peck)
		deck.append(peck)
		peck.visible = false
#	add_attack(preload("res://scenes/Attacks/Attack_Flirt.tscn"), 1, 1, 5)
#	var enemy_action = preload("res://scenes/Attacks/Enemy_Kiss.tscn").instance()
#	enemy_action.init(2, 0, 5)
#	add_child(enemy_action)
#	suspended_cards.push_front([enemy_action, -1])
func dinosaur_start():
	scene = "dinosaurs"
	state = STATE_START_OF_TURN
	suspended_cards = []
	selected_card = -1
	selected_birb = -1
	curr_animation = null 	
	enemies[0].texture = preload("res://sprites/tyrannosaurus_idle.png")
	enemies[1].texture = preload("res://sprites/stegosaurus_idle.png")
	enemies[2].texture = preload("res://sprites/brachiosaurus_idle.png")	
	enemies[3].texture = preload("res://sprites/pterodactyl_idle.png")	
	var enemy_max_hp = [40, 60, 48, 40]
	for i in range(4):
		enemies[i].init(enemy_max_hp[i])
	get_node("Background").visible = false
	var g = preload("res://scenes/Galaxy_Background.tscn").instance()
	add_child(g)
		
func add_action(scene, params):
	var enemy_action = scene.instance()
	if len(params) == 1:
		enemy_action.init(params[0])
	if len(params) == 2:
		enemy_action.init(params[0], params[1])
	if len(params) == 3:
		enemy_action.init(params[0], params[1], params[2])
	if len(params) == 4:
		enemy_action.init(params[0], params[1], params[2], params[3])
	add_child(enemy_action)
	suspended_cards.push_front([enemy_action, -1])	
		
func add_attack(scene, enemy, target, amount):
	var a = scene.instance()
	a.init(enemy, target, amount)
	add_child(a)
	enemies[enemy].attacks.append(a)

func add_suspended_card_front(scene, target):
	var d = scene.instance()
	add_child(d)
	suspended_cards.push_front([d, target])		
	
func add_suspended_card_back(scene, target):
	var d = scene.instance()
	add_child(d)
	suspended_cards.push_back([d, target])		

func add_to_discard(card):
	if !(card in get_children()):
		add_child(card)
	card.visible = false
	discard.append(card)
	add_child(preload("res://scenes/Particles/Particle_Discard_In.tscn").instance())

func play_card_random_target(card):
	var target = -1
	if card.target_type == "enemy":
		target = random_living_enemy()
		if target == -1:
			return
	if card.target_type == "birb":
		target = other_random_living_birb(selected_birb)
		if target == -1:
			return
	suspended_cards.push_front([card, target])

func concede():
	for i in range(4):
		if birbs[i].hp > 0:
			for j in range(30):
				var p = preload("res://scenes/Particles/Particle_Explosion.tscn").instance()
				add_child(p)
				p.init(helpers.default_birb_pos(i))
		birbs[i].hp = 0
	sound_effect_player.load_and_play(preload("res://sounds/explosion_long.wav"))

func damage_enemy(source, target, amount):
	if target < 0 or target > 3:
		return
	var enemy = enemies[target]
	var birb = null
	if source != -1:
		birb = birbs[source]
	if enemy.hp <= 0:
		return
	if enemy.effects["shattered"] > 0:
		amount *= 2
		enemy.effects["shattered"] -= 1
	amount += enemy.effects["frozen"]
	if enemy.effects["thorns"] > 0:
		amount += 1
		enemy.effects["thorns"] -= 1
	if enemy.effects["immune"] > 0:
		amount = 0
	if enemy.effects["defence"] > 0:
		var k = min(amount, enemy.effects["defence"])
		amount -= k
		enemy.effects["defence"] -= k

	if enemy.hp <= amount:
		enemy.hp = 0
		enemy.attacks = []
		for effect in enemy.effects:
			enemy.effects[effect] = 0
	else:
		enemy.hp -= amount
	if amount > 0:
		enemy.effects["hustle"] = 0
	if birb and birb.effects["bloodthirsty"] > 0:
		heal_birb(source, amount)
	if amount > 0 and target == 1 and scene == "swanmother":
		enemies[1].increase_effect("rage", 1)
	var p = preload("res://scenes/Particles/Particle_Damage_Number.tscn").instance()
	p.init(enemy.position + enemy.offset)
	p.text = str(amount)
	add_child(p)
	return amount

func damage_birb(source, target, amount):
	var enemy = null
	if source != -1:
		enemy = enemies[source]
	var birb = birbs[target]
	if birb.hp <= 0:
		return 0
	if birb.effects["shattered"] > 0:
		amount *= 2
		birb.effects["shattered"] -= 1
	if enemy and enemy.effects["weakened"] > 0:
		amount = int(amount / 2)
	amount += birb.effects["frozen"]
	if birb.effects["parrying"] > 0:
		var k = min(amount, birb.effects["parrying"])
		amount -= k
		birb.effects["parrying"] -= k
		if enemy:
			damage_enemy(target, source, k)
			get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/parry_card-002.wav"))
			var p = preload("res://scenes/Particles/Particle_Parry_Cross.tscn").instance()
			p.init(enemy.position + enemy.offset)
			add_child(p)
	if birb.effects["immune"] > 0:
		amount = 0
	if birb.effects["defence"] > 0:
		var k = min(amount, birb.effects["defence"])
		amount -= k
		birb.effects["defence"] -= k
	if birb.hp <= amount:
		birb.hp = 0
		for effect in birb.effects:
			birb.effects[effect] = 0
	else:
		birb.hp -= amount
	if amount > 0:
		birb.effects["fortified"] = 0
	var p = preload("res://scenes/Particles/Particle_Damage_Number.tscn").instance()
	p.init(birb.position + birb.offset)
	p.text = str(amount)
	add_child(p)
	return amount

func heal_birb(index, amount):
	var birb = birbs[index]
	if birb.hp <= 0:
		return
	if birb.max_hp - birb.hp < amount:
		amount = birb.max_hp - birb.hp
	birbs[index].hp += amount
	var p = preload("res://scenes/Particles/Particle_Heal_Number.tscn").instance()
	p.init(birb.position + birb.offset)
	p.text = str(amount)
	add_child(p)	
	
func heal_enemy(index, amount):
	var enemy = enemies[index]
	if enemy.hp <= 0:
		return
	if enemy.max_hp - enemy.hp < amount:
		amount = enemy.max_hp - enemy.hp
	enemy.hp += amount
	var p = preload("res://scenes/Particles/Particle_Heal_Number.tscn").instance()
	p.init(enemy.position + enemy.offset)
	p.text = str(amount)
	add_child(p)

func set_default_locations():
	for i in range(7):
		if hand[i]:
			hand[i].position = Vector2(5 + 100 * i, 405)
	for birb in birbs:
		birb.position = Vector2(0, 0)
	for enemy in enemies:
		enemy.position = Vector2(0, 0)
	for birb_plate in birb_plates:
		birb_plate.position = Vector2(0, 0)
	for enemy_plate in enemy_plates:		
		enemy_plate.position = Vector2(0, 0)
	if state == STATE_SELECT_BIRB or state == STATE_SELECT_TARGET:
		hand[selected_card].position += Vector2(0, -50)
	if state == STATE_SELECT_TARGET:
		birbs[selected_birb].position += Vector2(50, 0)
		birb_plates[selected_birb].position += Vector2(50, 0)

func start_victory_defeat():
	var birbs_alive = false
	var enemies_alive = false
	for birb in birbs:
		if birb.hp > 0:
			birbs_alive = true
	for enemy in enemies:
		if enemy.hp > 0:
			enemies_alive = true
	if not enemies_alive:
		get_parent().advance_victory()
	if not birbs_alive:
		get_parent().advance_defeat()

func _process(delta):
	# animate background
	autoselect_no_choice()
	set_default_locations()
	handle_tooltip()
	start_victory_defeat()
	
	if curr_animation:
		if !curr_animation.animate(delta):
			apply_screen_shake(delta)
			return
		curr_animation = null
	start_victory_defeat()
	if len(suspended_cards) > 0:
		var k = suspended_cards.pop_front()
		resolve_card(k[0], k[1])
		apply_screen_shake(delta)
		return
	if !curr_animation:
		idle_animation(delta)
		pass
	handle_state()
	autoselect_no_choice()
	apply_screen_shake(delta)

func handle_tooltip():
	var mpos = get_viewport().get_mouse_position()
	get_node("Tooltip").visible = false
	for birb_plate in birb_plates:
		var rpos = mpos - (birb_plate.position + birb_plate.offset)
		if rpos.x > 2 and rpos.x < 207 and rpos.y > 53 and rpos.y < 77:
			var slot = int((rpos.x - 2) / 41)
			for effect in birb_plate.birb.effects:
				if birb_plate.birb.effects[effect] > 0:
					if slot == 0:
						get_node("Tooltip").visible = true
						get_node("Tooltip/Icon").texture = helpers.effect_sprite(effect)
						var amount = birb_plate.birb.effects[effect]
						get_node("Tooltip/Icon/Number").text = str(amount)
						get_node("Tooltip").position = mpos
						get_node("Tooltip/Description").text = helpers.effect_description_birb(effect, amount)
					slot -= 1
	for enemy_plate in enemy_plates:
		var rpos = mpos - (enemy_plate.position + enemy_plate.offset)
		if rpos.x > 2 and rpos.x < 207 and rpos.y > 53 and rpos.y < 77:
			var slot = int((rpos.x - 2) / 41)
			for effect in enemy_plate.enemy.effects:
				if enemy_plate.enemy.effects[effect] > 0:
					if slot == 0:
						get_node("Tooltip").visible = true
						get_node("Tooltip/Icon").texture = helpers.effect_sprite(effect)
						var amount = enemy_plate.enemy.effects[effect]
						get_node("Tooltip/Icon/Number").text = str(amount)
						get_node("Tooltip").position = mpos	
						get_node("Tooltip/Description").text = helpers.effect_description_enemy(effect, amount)
					slot -= 1
		if rpos.x > 2 and rpos.x < 164 and rpos.y > 3 and rpos.y < 27:
			var slot = int((rpos.x - 2) / 41)
			if len(enemy_plate.enemy.attacks) > slot:
					get_node("Tooltip").visible = true
					var tex
					var desc
					if enemy_plate.enemy.attacks[slot].basic_attack:
						desc = "This enemy will deal %d damage to %b this turn"
						tex = enemy_plate.basic_attack_sprites[enemy_plate.enemy.attacks[slot].target_birb]
					else:
						desc = "This enemy will deal %d damage with an additional effect to %b this turn"
						tex = enemy_plate.effect_attack_sprites[enemy_plate.enemy.attacks[slot].target_birb]
					desc = desc.replace("%d", enemy_plate.enemy.attacks[slot].damage)
					var birb_names = ["Hawk", "Finch", "Peacock", "Swan"]
					desc = desc.replace("%b", birb_names[enemy_plate.enemy.attacks[slot].target_birb])
					get_node("Tooltip/Icon").texture = tex							
					get_node("Tooltip/Icon/Number").text = str(enemy_plate.enemy.attacks[slot].damage)
					get_node("Tooltip").position = mpos		
					get_node("Tooltip/Description").text = desc
					
	if get_node("Tooltip").position.x > 500:
		get_node("Tooltip").position.x -= 300

func handle_state():
	if state == STATE_END_OF_TURN:
		pass
		state = STATE_DAMAGE_TICKS
	elif state == STATE_DAMAGE_TICKS:
		for i in range(8):
			add_suspended_card_back(preload("res://scenes/Animations/Anim_Volley_Tick.tscn"), i)
		for i in range(8):
			add_suspended_card_back(preload("res://scenes/Animations/Anim_Fire_Tick.tscn"), i)
		for i in range(8):
			add_suspended_card_back(preload("res://scenes/Animations/Anim_Radiance_Tick.tscn"), i)		
		for i in range(8):
			add_suspended_card_back(preload("res://scenes/Animations/Anim_Quake_Tick.tscn"), i)		
		state = STATE_ENEMY_ATTACKS
	elif state == STATE_ENEMY_ATTACKS:
		for enemy in enemies:
			for attack in enemy.attacks:
				suspended_cards.push_back([attack, -1])
		state = STATE_FORTIFY_TICK
	elif state == STATE_FORTIFY_TICK:
		for i in range(4):
			if birbs[i].hp > 0:
				add_suspended_card_back(preload("res://scenes/Animations/Anim_Fortify_Tick.tscn"), i)
		state = STATE_EFFECT_DECAY
	elif state == STATE_EFFECT_DECAY:
		for ch in birbs + enemies:
			ch.effects["defence"] = 0
			ch.effects["parrying"] = 0
			if ch.effects["weakened"] > 0:
				ch.effects["weakened"] -= 1
			if ch.effects["bloodthirsty"] > 0:
				ch.effects["bloodthirsty"] -= 1
			ch.effects["shattered"] = ch.effects["shattered_imminent"]
			ch.effects["shattered_imminent"] = 0
			ch.effects["frozen"] = ch.effects["frozen_delayed"]
			ch.effects["frozen_delayed"] = 0
			if ch.effects["immune_imminent"] > 0:
				ch.effects["immune"] = 1
				ch.effects["immune_imminent"] -= 1
			else:
				ch.effects["immune"] = 0
		for birb in birbs:
			birb.effects["hustle"] = birb.effects["hustle_delayed"]
			birb.effects["hustle_delayed"] = 0
		for enemy in enemies:
			enemy.attacks = []
		state = STATE_START_OF_TURN
	elif state == STATE_START_OF_TURN:
		if not rewind_tutorial_if_failed() and not get_parent().in_victory:
			turn_count += 1
			var p = preload("res://scenes/Particles/Particle_Your_Turn.tscn").instance()
			add_child(p)
			times_rewinded = 0
			sound_effect_player.load_and_play(preload("res://sounds/start_of_turn-003.wav"))
		state = STATE_REGAIN_ACTIONS
	elif state == STATE_REGAIN_ACTIONS:
		for birb in birbs:
			if birb.hp > 0:
				birb.actions = 1
				if birb.effects["prepared"] > 0:
					birb.effects["prepared"] -= 1
					birb.actions += 1
				if birb.effects["stun"] > 0:
					birb.effects["stun"] -= 1
					birb.actions -= 1
			else:
				birb.actions = 0
		state = STATE_DRAW_FOR_TURN
	elif state == STATE_DRAW_FOR_TURN:
		if scene != "tutorial_1" and scene != "tutorial_2":
			for _i in range(5):
				add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		state = STATE_ENEMY_STRATEGY
	elif state == STATE_ENEMY_STRATEGY:
		if scene == "tutorial_1":
			script_tutorial_1()
		elif scene == "tutorial_2":
			script_tutorial_2()
		elif scene == "magpie":
			ai_magpie()
		elif scene == "jocks":
			ai_jocks()
		elif scene == "fangirls":
			ai_fangirls()
		elif scene == "peep":
			ai_peep_top()
		elif scene == "pidgeons":
			ai_pidgeons()
		elif scene == "goose":
			ai_goose()
		elif scene == "duck":
			ai_duck()
		elif scene == "swanmother":
			ai_swanmother()
		elif scene == "chickens":
			ai_chickens()
		elif scene == "pheasant":
			ai_pheasant()
		elif scene == "dinosaurs":
			ai_dinosaurs_easy()
		state = STATE_CHOICE

func rewind_tutorial_if_failed():
	if scene == "tutorial_1" and turn_count == 4:
		if birbs[0].hp <= 0 or birbs[1].hp <= 0:
			add_suspended_card_back(preload("res://scenes/Animations/Anim_Rewind.tscn"), -1)
			return true
	if scene == "tutorial_2" and turn_count == 1:
		if birbs[0].effects["stun"] > 0 or birbs[2].effects["stun"] > 0 or birbs[3].effects["stun"] > 0 or enemies[0].effects["aflame"] == 0:
			add_suspended_card_back(preload("res://scenes/Animations/Anim_Rewind.tscn"), -1)
			return true			
	if scene == "tutorial_2" and turn_count in [2,3]:
		if birbs[0].hp <= 0 or birbs[1].hp <= 0 or birbs[2].hp <= 0 or birbs[3].hp <= 0:
			add_suspended_card_back(preload("res://scenes/Animations/Anim_Rewind.tscn"), -1)
			return true		
	return false
	
func card_tray_active():
	return curr_animation == null and state in [STATE_CHOICE, STATE_SELECT_BIRB, STATE_SELECT_TARGET]

func autoselect_no_choice():
	if state == STATE_SELECT_BIRB:
		var c = hand[selected_card]
		var usable = []
		for i in range(4):
			if card_can_be_played(c, i):
				usable.append(i)
		if len(usable) == 0:
			state = STATE_CHOICE
		if len(usable) == 1:
			selected_birb = usable[0]
			state = STATE_SELECT_TARGET
	if state == STATE_SELECT_TARGET:
		var c = hand[selected_card]
		if c.target_type == "none" and not curr_animation:
			play_card(0)
			state = STATE_CHOICE	
	
func idle_animation(delta):
	idle_timer += delta
	for birb in birbs:
		if birb.hp > 0:
			var period = float(birb.max_hp) / birb.hp
			if fmod(idle_timer, period) > period / 2:
				birb.position += Vector2(0, -2)
			if birb.effects["confused"] > 0:
				birb.position += Vector2(5 * sin(idle_timer * 1.3),0)
	for enemy in enemies:
		if enemy.hp > 0:
			var period = float(enemy.max_hp) / enemy.hp
			if enemy.effects["quick"] > 0:
				period = 0.75 / enemy.effects["quick"]
			if fmod(idle_timer, period)  > period / 2:
				enemy.position += Vector2(0, -2)

func birb_battle_dialogue(speaker, text):
	var p = preload("res://scenes/Particles/Battle_Dialogue.tscn").instance()
	add_child(p)
	p.set_text(text)
	p.set_enemy_speaking(false)
	p.set_speaker_pos(helpers.default_birb_pos(speaker))
	
func tutorial_no_sell(c, target):
	if scene != "tutorial_1":
		return false
	if turn_count == 2:
		if c.card_name == "Peck":
			if selected_birb == 1:
				birb_battle_dialogue(1, "I need to defend myself!")
				return true
			if target == 1:
				birb_battle_dialogue(0, "That one is defending; I won't do any damage.")
				return true
		if c.card_name == "Guard":
			if selected_birb == 0:
				birb_battle_dialogue(0, "No one is attacking me.")
				return true
	if turn_count == 3:
		if c.card_name == "Peck" or c.card_name == "Guard":
			if selected_birb == 0:
				birb_battle_dialogue(0, "If I use Swipe, I can hit both of them")
				return true
			if selected_birb == 1:
				birb_battle_dialogue(1, "I want to give them a piece of my mind!")
				return true
	return false
	
func play_card(target):
	var c = hand[selected_card]
	
	if tutorial_no_sell(c, target):
		return
	
	if birbs[selected_birb].effects["confused"] > 0:
		birbs[selected_birb].effects["confused"] -= 1
		if hand[selected_card].target_type == "birb":
			target = other_random_living_birb(selected_birb)
		if hand[selected_card].target_type == "enemy":
			target = random_living_enemy()
		sound_effect_player.load_and_play(preload("res://sounds/confusion_trigger.wav"))
	if "consumable" in c:
		for _i in range(40):
			var p = preload("res://scenes/Particles/Particle_Flame.tscn").instance()
			p.init(c.position + Vector2(rand_range(0, 90), rand_range(0, 190)))
			add_child(p)
		hand[selected_card] = null
		c.visible = false
	else:
		hand[selected_card] = null
		discard.append(c)
		c.visible = false
		add_child(preload("res://scenes/Particles/Particle_Discard_In.tscn").instance())
		
	birbs[selected_birb].actions -= 1
	
	if birbs[selected_birb].effects["hustle"] > 0:
		birbs[selected_birb].effects["hustle"] -= 1
		suspended_cards.push_back([c, target])
	
	resolve_card(c, target)
	
func resolve_card(card, target):
	# check for invalid targets, players, etc.
	curr_animation = card
	curr_animation.resolve(selected_birb, target) 
	pass

func card_can_be_played(card, birb):
	if birbs[birb].hp <= 0:
		return false
	if birbs[birb].actions <= 0:
		return false
	if card.type == "any":
		return true
	if card.type == "hawk":
		return birb == 0
	if card.type == "finch":
		return birb == 1
	if card.type == "peacock":
		return birb == 2
	if card.type == "swan":
		return birb == 3
	if card.type == "hawk_finch":
		return birb == 0 or birb == 1
	if card.type == "hawk_peacock":
		return birb == 0 or birb == 2
	if card.type == "hawk_swan":
		return birb == 0 or birb == 3
	if card.type == "finch_peacock":
		return birb == 1 or birb == 2
	if card.type == "finch_swan":
		return birb == 1 or birb == 3
	if card.type == "peacock_swan":
		return birb == 2 or birb == 3
	return false
	
func any_card_can_be_played():
	for card in hand:
		if card:
			for birb in range(4):
				if card_can_be_played(card, birb):
					return true
	return false
	
func random_living_birb():
	var n = 0
	for i in range(4):
		if birbs[i].hp > 0:
			n += 1
	if n == 0:
		return -1
	var k = randi() % n
	for i in range(4):
		if birbs[i].hp > 0:
			if k == 0:
				return i
			k -= 1
	
func other_random_living_birb(b):
	var n = 0
	for i in range(4):
		if birbs[i].hp > 0 and i != b:
			n += 1
	if n == 0:
		return -1
	var k = randi() % n
	for i in range(4):
		if birbs[i].hp > 0 and i != b:
			if k == 0:
				return i
			k -= 1
	
func random_living_enemy():
	var n = 0
	for i in range(4):
		if enemies[i].hp > 0:
			n += 1
	if n == 0:
		return -1
	var k = randi() % n
	for i in range(4):
		if enemies[i].hp > 0:
			if k == 0:
				return i
			k -= 1
	
func other_random_living_enemy(b):
	var n = 0
	for i in range(4):
		if enemies[i].hp > 0 and i != b:
			n += 1
	if n == 0:
		return -1
	var k = randi() % n
	for i in range(4):
		if enemies[i].hp > 0 and i != b:
			if k == 0:
				return i
			k -= 1
	
func tutorial_block_end_turn():
	if scene == "tutorial_2" and turn_count == 1 and birbs[2].actions > 0:
		birb_battle_dialogue(2, "... Can I help?")
		return true
	if scene != "tutorial_1":
		return false
	if turn_count == 1 and hand[0]:
		return true
	if turn_count == 2 and hand[1]:
		birb_battle_dialogue(0, "I can still deal some damage!")
		return true
	if turn_count == 2 and hand[0]:
		birb_battle_dialogue(1, "Wait, I'm not done yet!")
		return true
	if turn_count == 3 and birbs[0].actions != 0:
		birb_battle_dialogue(0, "Let me at them!")
		return true
	if turn_count == 3 and birbs[1].actions != 0:
		birb_battle_dialogue(1, "I still got fire to spit!")
		return true
	return false
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var x = event.position.x
			var y = event.position.y
			if y > 400 and y < 450 and x > 700:
				var m = preload("res://scenes/Pause_Menu.tscn").instance()
				add_child(m)
				get_tree().paused = true
			elif state == STATE_CHOICE:
				if y > 400 and x < 700:
					var i = int(x / 100)
					if hand[i]:
						state = STATE_SELECT_BIRB
						selected_card = i
						sound_effect_player.load_and_play(preload("res://sounds/click_neutral-001.wav"))
				elif y > 550 and x > 700: 
					if not tutorial_block_end_turn():
						state = STATE_END_OF_TURN
						sound_effect_player.load_and_play(preload("res://sounds/click_positive-003.wav"))
					else:
						sound_effect_player.load_and_play(preload("res://sounds/click_negative-005.wav"))
			elif state == STATE_SELECT_BIRB:
				if y > 400 and x < 700:
					var i = int(x / 100)
					if hand[i] and selected_card != i:
						selected_card = i
						sound_effect_player.load_and_play(preload("res://sounds/click_neutral-001.wav"))
				elif y < 360 and x < 300:
					var i = int(y / 90)
					if card_can_be_played(hand[selected_card], i):
						state = STATE_SELECT_TARGET
						selected_birb = i
						sound_effect_player.load_and_play(preload("res://sounds/click_neutral-001.wav"))
				elif y > 550 and x > 700:
					state = STATE_CHOICE
					sound_effect_player.load_and_play(preload("res://sounds/click_neutral-001.wav"))
			elif state == STATE_SELECT_TARGET:
				if y < 360 and x > 485 and hand[selected_card].target_type == "enemy":
					var i = int(y / 90)
					if enemies[i].hp > 0 and not curr_animation:
						play_card(i)
						state = STATE_CHOICE
						sound_effect_player.load_and_play(preload("res://sounds/click_neutral-001.wav"))
				elif y < 360 and x < 300 and hand[selected_card].target_type == "birb":
					var i = int(y / 90)
					if birbs[i].hp > 0 and i != selected_birb and not curr_animation:
						play_card(i)
						state = STATE_CHOICE
						sound_effect_player.load_and_play(preload("res://sounds/click_neutral-001.wav"))
				elif y < 360 and x < 300 and hand[selected_card].target_type != "birb":
					var i = int(y / 90)
					if card_can_be_played(hand[selected_card], i):
						selected_birb = i
						sound_effect_player.load_and_play(preload("res://sounds/click_neutral-001.wav"))
				elif y > 400 and x < 700:
					var i = int(x / 100)
					if hand[i] and selected_card != i:
						state = STATE_SELECT_BIRB
						selected_card = i
						sound_effect_player.load_and_play(preload("res://sounds/click_neutral-001.wav"))
				elif y > 550 and x > 700:
					state = STATE_CHOICE
					sound_effect_player.load_and_play(preload("res://sounds/click_neutral-001.wav"))
		
var screen_shake_active = false
var screen_shake_elapsed = 0
var screen_shake_offset

func start_screen_shake(amount):
	screen_shake_active = true
	screen_shake_elapsed = 0
	screen_shake_offset = Vector2(amount, 0).rotated(rand_range(-PI, PI))
	
func apply_screen_shake(delta):
	if screen_shake_active:
		screen_shake_elapsed += delta
		var offset = screen_shake_offset * cos(screen_shake_elapsed * 7.5 * PI) * (1 - screen_shake_elapsed * 5)
		for card in hand:
			if card:
				card.position += offset
		for birb in birbs:
			if birb.visible:
				birb.position += offset
		for enemy in enemies:
			if enemy.visible:
				enemy.position += offset
		for birb_plate in birb_plates:
			if birb_plate.visible:
				birb_plate.position += offset
		for enemy_plate in enemy_plates:
			if enemy_plate.visible:
				enemy_plate.position += offset				
		if screen_shake_elapsed > 0.2:
			screen_shake_active = false

func ai_magpie():
	if enemies[2].hp > 0:
		for i in range(4):
			if birbs[i].effects["shattered"] > 0:
				add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 2, i, 4)
				break
			if i == 3:
				add_attack(preload("res://scenes/Attacks/Attack_Kneecap.tscn"), 2, random_living_birb(), 1)
	if enemies[1].hp > 0:
		if enemies[0].hp > 0 or enemies[2].hp > 0:
			add_action(preload("res://scenes/Attacks/Enemy_Shield.tscn"), [1, other_random_living_enemy(1), 6])
		if enemies[0].hp == 0 or enemies[2].hp == 0:
			add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 1, random_living_birb(), 3)
		if enemies[0].hp == 0 and enemies[2].hp == 0:
			add_action(preload("res://scenes/Attacks/Enemy_Guard.tscn"), [1, 5])
	if enemies[0].hp > 0:
		if randf() > 0.30 or enemies[2].hp == 0:
			add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 0, random_living_birb(), 3)             
		else:
			add_action(preload("res://scenes/Attacks/Enemy_Guard.tscn"), [0, 5])
			
func ai_jocks():
	if enemies[0].hp > 0 and enemies[1].hp <= 0 and enemies[2].hp <= 0 and enemies[3].hp <= 0:
		add_attack(preload("res://scenes/Attacks/Attack_Basic_Swipe.tscn"), 0, random_living_birb(), 7)
	var a = 3
	if enemies[0].hp > 0:
		a = 4
	if enemies[0].hp > 0 and (enemies[1].hp <= 0 or enemies[2].hp <= 0 or enemies[3].hp <= 0):
		add_attack(preload("res://scenes/Attacks/Attack_Basic_Swipe.tscn"), 0, random_living_birb(), a)
	if enemies[0].hp > 0 and turn_count % 2 == 1:
		add_action(preload("res://scenes/Attacks/Enemy_Hustle_All.tscn"), [0])    
	else:
		for i in range(1, 4):
			if enemies[i].hp > 0:
				if enemies[i].effects["hustle"] > 0:
					enemies[i].effects["hustle"]  = 0
					add_attack(preload("res://scenes/Attacks/Attack_Basic_Swipe.tscn"), i, random_living_birb(), a)
					add_attack(preload("res://scenes/Attacks/Attack_Basic_Swipe.tscn"), i, random_living_birb(), a)
				elif enemies[0].hp <= 0 and randf() > 0.6:
					add_action(preload("res://scenes/Attacks/Enemy_Hustle_Self.tscn"), [i])    
				else:
					add_attack(preload("res://scenes/Attacks/Attack_Basic_Swipe.tscn"), i, random_living_birb(), a)

func ai_fangirls():
	var absences = []
	for i in [2, 1, 0]:
		if enemies[i].hp > 0:
			if randf() > 0.5:
				add_action(preload("res://scenes/Attacks/Enemy_Hype.tscn"), [i, 1])    
			else:
				var a = 3
				for j in range(enemies[i].effects["hype"]):
					a *= 2
				add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), i, random_living_birb(), a)  
		else:
			absences.append(i) 
	if enemies[3].hp > 0:
		if len(absences) == 0:
			add_action(preload("res://scenes/Attacks/Enemy_Guard.tscn"), [3, 10])    
		elif len(absences) == 1:
			add_attack(preload("res://scenes/Attacks/Attack_Basic_Jump_Out.tscn"), 3, random_living_birb(), 3)
		else:
			if randf() < 0.5:
				add_attack(preload("res://scenes/Attacks/Attack_Basic_Jump_Out.tscn"), 3, random_living_birb(), 3)
			else:
				add_attack(preload("res://scenes/Attacks/Attack_Basic_Jump_Out.tscn"), 3, random_living_birb(), 1)
				add_attack(preload("res://scenes/Attacks/Attack_Basic_Jump_Out.tscn"), 3, random_living_birb(), 1)

var last_spotlight = -1

func ai_peep_top():
	var spotlight = other_random_living_enemy(last_spotlight)
	if turn_count == 1 and enemies[0].hp > 0:
		spotlight = 0
	if turn_count == 2 and enemies[1].hp > 0:
		spotlight = 1
	if turn_count == 3 and enemies[2].hp > 0:
		spotlight = 2
	if turn_count == 4 and enemies[3].hp > 0:
		spotlight = 3
	if spotlight == -1:
		spotlight = random_living_enemy()
	last_spotlight = spotlight
	add_action(preload("res://scenes/Attacks/Enemy_Spotlight.tscn"), [spotlight, 4, 1])

func ai_peep_bottom(active_enemy):
	if active_enemy == 0:
		if enemies[0].effects["kissed"] > 0:
			enemies[0].effects["kissed"] = 0
			add_attack(preload("res://scenes/Attacks/Attack_Basic_Robin.tscn"), 0, random_living_birb(), 2)
			add_attack(preload("res://scenes/Attacks/Attack_Basic_Robin.tscn"), 0, random_living_birb(), 3)
			add_attack(preload("res://scenes/Attacks/Attack_Basic_Robin.tscn"), 0, random_living_birb(), 4)
			add_attack(preload("res://scenes/Attacks/Attack_Basic_Robin.tscn"), 0, random_living_birb(), 5)
		else:
			add_attack(preload("res://scenes/Attacks/Attack_Basic_Robin.tscn"), 0, random_living_birb(), 1)
			add_attack(preload("res://scenes/Attacks/Attack_Basic_Robin.tscn"), 0, random_living_birb(), 2)
			add_attack(preload("res://scenes/Attacks/Attack_Basic_Robin.tscn"), 0, random_living_birb(), 3)
			add_attack(preload("res://scenes/Attacks/Attack_Basic_Robin.tscn"), 0, random_living_birb(), 4)			
	if active_enemy == 1:
		if enemies[1].effects["kissed"] > 0:
			enemies[1].effects["kissed"] = 0
			add_attack(preload("res://scenes/Attacks/Attack_Stun_Trash.tscn"), 1, random_living_birb(), 4)
			add_attack(preload("res://scenes/Attacks/Attack_Stun_Trash.tscn"), 1, random_living_birb(), 4)
		else:
			add_attack(preload("res://scenes/Attacks/Attack_Stun_Trash.tscn"), 1, random_living_birb(), 2)
			add_attack(preload("res://scenes/Attacks/Attack_Stun_Trash.tscn"), 1, random_living_birb(), 2)
	if active_enemy == 2:
		if enemies[2].effects["kissed"] > 0:
			enemies[2].effects["kissed"] = 0
			add_action(preload("res://scenes/Attacks/Enemy_Volley.tscn"), [2, random_living_birb(), 9])  
		else:
			add_action(preload("res://scenes/Attacks/Enemy_Volley.tscn"), [2, random_living_birb(), 6])
	if active_enemy == 3:
		if enemies[3].effects["kissed"] > 0:
			enemies[3].effects["kissed"] = 0
			add_attack(preload("res://scenes/Attacks/Attack_Basic_Trample.tscn"), 3, random_living_birb(), 5)
			add_attack(preload("res://scenes/Attacks/Attack_Basic_Trample.tscn"), 3, random_living_birb(), 5)
			add_attack(preload("res://scenes/Attacks/Attack_Basic_Trample.tscn"), 3, random_living_birb(), 5)
		else:
			add_action(preload("res://scenes/Attacks/Enemy_Kiss.tscn"), [3, random_living_enemy(), 5])

func ai_pidgeons():
	if enemies[1].hp > 0:
		if enemies[0].hp <= 0 and enemies[2].hp <= 0:
			for i in range(4):
				if birbs[i].hp > 0:
					add_attack(preload("res://scenes/Attacks/Attack_Confuse_Coo.tscn"), 1, i, 2)
			add_action(preload("res://scenes/Attacks/Enemy_Shield_Coo.tscn"), [1, 1, 4])    
		else:
			if randf() > 0.6:
				add_attack(preload("res://scenes/Attacks/Attack_Confuse_Coo.tscn"), 1, random_living_birb(), 4)
			elif randf() > 0.5:
				for i in range(3):
					if enemies[i].hp > 0:
						add_action(preload("res://scenes/Attacks/Enemy_Shield_Coo.tscn"), [1, i, 4])  
			else:
				for i in range(4):
					if birbs[i].hp > 0:
						add_attack(preload("res://scenes/Attacks/Attack_Basic_Coo.tscn"), 1, i, 1)
	for en in [0, 2]:
		if enemies[en].hp > 0:
			if enemies[en].effects["quick"] < 3 and turn_count >= enemies[en].effects["quick"] * 3 + 2:
				if turn_count >= enemies[en].effects["quick"] * 3 + 5 or randf() > 0.6:
					add_action(preload("res://scenes/Attacks/Enemy_Quicken.tscn"), [en, 5]) 
					continue
			var a = 2
			for i in range(enemies[en].effects["quick"] + 1):
				if enemies[en].effects["quick"] > 0:
					add_attack(preload("res://scenes/Attacks/Attack_Basic_Quick.tscn"), en, random_living_birb(), a)
				else:
					add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), en, random_living_birb(), a)
				a += 1

func ai_swanmother():
	if enemies[2].hp > 0:
		for i in range(4):
			if birbs[i].effects["shattered"] > 0:
				add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 2, i, 4)
				break
			if i == 3:
				add_attack(preload("res://scenes/Attacks/Attack_Kneecap.tscn"), 2, random_living_birb(), 1)
	if enemies[0].hp > 0:
		var swan = 3
		var other_birb = -1
		for i in range(3):
			if birbs[i].hp > 0:
				other_birb = i
		if birbs[3].hp <= 0:
			damage_enemy(-1, 0, 1)
			add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 0, random_living_birb(), helpers.rand_choice([3, 4, 5]))
		elif other_birb == -1:
			add_attack(preload("res://scenes/Attacks/Attack_Flirt.tscn"), 0, swan, helpers.rand_choice([2, 3]))
		elif turn_count % 3 == 1:
			add_attack(preload("res://scenes/Attacks/Attack_Flirt.tscn"), 0, swan, helpers.rand_choice([2, 3]))
		elif turn_count % 3 == 2:
			add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 0, other_random_living_birb(swan), helpers.rand_choice([3, 4]))
		elif turn_count % 3 == 0 and enemies[0].hp < enemies[0].max_hp / 2:
			add_action(preload("res://scenes/Attacks/Enemy_Guard.tscn"), [0, helpers.rand_choice([3, 4, 5])]) 
		else:
			add_attack(preload("res://scenes/Attacks/Attack_Flirt.tscn"), 0, swan, helpers.rand_choice([2, 3]))
	if enemies[1].hp > 0:
		if turn_count == 1 or (turn_count != 2 and enemies[0].hp > 0 and enemies[2].hp > 0 and randf() < 0.25):
			add_action(preload("res://scenes/Attacks/Enemy_Shield.tscn"), [1, 2, 6])  
			add_action(preload("res://scenes/Attacks/Enemy_Shield.tscn"), [1, 0, 6])  
		elif turn_count == 2 or ((enemies[0].hp > 0 or enemies[2].hp > 0) and randf() < 0.3):
			add_action(preload("res://scenes/Attacks/Enemy_Blood_Rite.tscn"), [1, 5])
		elif enemies[0].hp > 0 and enemies[2].hp > 0 and enemies[1].effects["rage"] < 3 and turn_count > 3 and randf() < 0.5:
			add_action(preload("res://scenes/Attacks/Enemy_Blood_Rite.tscn"), [1, 5])
		elif enemies[1].hp < enemies[1].max_hp and randf() < 0.5:
			add_attack(preload("res://scenes/Attacks/Attack_Extort_Swan.tscn"), 1, random_living_birb(), enemies[1].effects["rage"])
		elif turn_count % 2 == 0:
			var a = random_living_birb()
			var b = other_random_living_birb(a)
			add_attack(preload("res://scenes/Attacks/Attack_Basic_Nevermore.tscn"), 1, a, enemies[1].effects["rage"])
			if b != a and b != -1:
				add_attack(preload("res://scenes/Attacks/Attack_Basic_Nevermore.tscn"), 1, b, enemies[1].effects["rage"])
		else:
			add_action(preload("res://scenes/Attacks/Enemy_Guard.tscn"), [1, enemies[1].effects["rage"]]) 
			add_attack(preload("res://scenes/Attacks/Attack_Basic_Nevermore.tscn"), 1, random_living_birb(), enemies[1].effects["rage"])

func ai_chickens():
	if turn_count % 5 == 3 or turn_count % 5 == 4:
		for i in range(4):
			if enemies[i].hp > 0:
				add_action(preload("res://scenes/Attacks/Enemy_Starbeaks.tscn"), [i, 1])
	else:
		var targets = []
		for _i in range(4):
			var k = randi() % 4
			for j in range(4):
				if birbs[(j + k) % 4].hp > 0 and not  ((j + k) % 4) in targets:
					targets.append((j + k) % 4)
					break
				if j == 3:
					targets.append(random_living_birb())

		var fire_matrix = {-3: [2], -2: [2], -1: [1, 2, 3], 0: [2, 3], 1: [3], 2: [2, 3, 4], 3: [3, 4]}
		var stun_matrix = {-3: [1], -2: [1], -1: [1], 0: [1, 2], 1: [1, 2, 3], 2: [2, 3], 3: [2, 3, 4]}
		var confuse_matrix = {-3: [1, 2], -2: [1, 2, 3], -1: [2, 3], 0: [2, 3, 4], 1: [3, 4], 2: [3, 4, 5], 3: [4, 5, 6]}
		var freeze_matrix = {-3: [1], -2: [1, 2], -1: [1, 2, 3], 0: [1, 2, 3], 1: [2, 3], 2: [2, 3, 4], 3: [3, 4]}
		var advantage = 0
		for i in range(4):
			if birbs[i].hp > 0:
				advantage += 1
			if enemies[i].hp > 0:
				advantage -= 1

		if enemies[0].hp > 0:
			add_attack(preload("res://scenes/Attacks/Attack_Fires.tscn"), 0, targets.pop_back(), helpers.rand_choice(fire_matrix[advantage]))
		if enemies[1].hp > 0:
			add_attack(preload("res://scenes/Attacks/Attack_Stun_Stone.tscn"), 1, targets.pop_back(), helpers.rand_choice(stun_matrix[advantage]))
		if enemies[2].hp > 0:
			add_attack(preload("res://scenes/Attacks/Attack_Confuse_Plasma.tscn"), 2, targets.pop_back(), helpers.rand_choice(confuse_matrix[advantage]))
		if enemies[3].hp > 0:
			add_attack(preload("res://scenes/Attacks/Attack_Freeze.tscn"), 3, targets.pop_back(), helpers.rand_choice(freeze_matrix[advantage]))

func ai_pheasant():
	if enemies[1].hp > 0 and turn_count % 3 == 0:
		add_attack(preload("res://scenes/Attacks/Attack_Basic_Bone_Explosion.tscn"), 1, random_living_birb(), int(rand_range(15,99)))
	if enemies[0].hp > 0:
		if turn_count % 3 == 1:
			if enemies[1].hp > 0:
				damage_enemy(-1, 1, 999)
			if randf() > 0.5:
				add_attack(preload("res://scenes/Attacks/Attack_Stun_Heptagram.tscn"), 0, random_living_birb(), 6)
			else:
				add_action(preload("res://scenes/Attacks/Enemy_Volley_Heptagram.tscn"), [0, random_living_birb(), 6])
		if turn_count % 3 == 2:
			add_action(preload("res://scenes/Attacks/Enemy_Summon_Bones.tscn"), [1, 9])
		if turn_count % 3 == 0:
			if randf() > 0.5 and enemies[1].hp > 0:
				add_action(preload("res://scenes/Attacks/Enemy_Guard_Heptagram.tscn"), [0, 3])
			else:
				add_attack(preload("res://scenes/Attacks/Attack_Extort_Heptagram.tscn"), 0, random_living_birb(), 5)

func ai_dinosaur_hawk(a):
	if a == 0:
		add_action(preload("res://scenes/Attacks/Enemy_Guard.tscn"), [0, 3])
	elif a == 1:
		add_action(preload("res://scenes/Attacks/Enemy_Hustle_One.tscn"), [0, other_random_living_enemy(0)])
	elif a == 2:
		add_attack(preload("res://scenes/Attacks/Attack_Basic_Quick.tscn"), 0, random_living_birb(), 1)
		add_attack(preload("res://scenes/Attacks/Attack_Basic_Quick.tscn"), 0, random_living_birb(), 1)
	elif a == 3:
		add_attack(preload("res://scenes/Attacks/Attack_Basic_Swipe.tscn"), 0, random_living_birb(), 4)
	elif a == 4:
		for i in range(4):
			if birbs[i].hp > 0:
				add_attack(preload("res://scenes/Attacks/Attack_Basic_Quick.tscn"), 0, i, 1)
	elif a == 5:
		for i in [1, 2, 3]:
			if enemies[i].hp > 0:
				add_action(preload("res://scenes/Attacks/Enemy_Hustle_One.tscn"), [0, i])
			else:
				add_attack(preload("res://scenes/Attacks/Attack_Basic_Quick.tscn"), 0, random_living_birb(), 2)
	elif a == 6:
		for i in range(4):
			if birbs[i].hp > 0:
				add_attack(preload("res://scenes/Attacks/Attack_Basic_Quick.tscn"), 0, i, 2)
	elif a == 7:
		add_attack(preload("res://scenes/Attacks/Attack_Basic_Swipe.tscn"), 0, random_living_birb(), 7)
	else:
		add_attack(preload("res://scenes/Attacks/Attack_Basic_Swipe.tscn"), 0, random_living_birb(), 7)
		add_action(preload("res://scenes/Attacks/Enemy_Hustle_Self.tscn"), [0])

func ai_dinosaur_finch(a):
	if a == 0:
		add_action(preload("res://scenes/Attacks/Enemy_Guard.tscn"), [1, 3])
	elif a == 1:
		var target = helpers.rand_choice([0,2,3])
		var damage = 0
		for i in [0, 2, 3]:
			if enemies[i].hp > 0 and enemies[i].max_hp - enemies[i].hp > damage:
				damage = enemies[i].max_hp - enemies[i].hp 
				target = i
		add_action(preload("res://scenes/Attacks/Enemy_Shield.tscn"), [1, target, 5])
	elif a == 2:
		add_attack(preload("res://scenes/Attacks/Attack_Stun_Trash.tscn"), 1, random_living_birb(), 2)
	elif a == 3:
		add_action(preload("res://scenes/Attacks/Enemy_Volley.tscn"), [1, random_living_birb(), 3])
	elif a == 4:
		add_attack(preload("res://scenes/Attacks/Attack_Basic_Robin.tscn"), 1, random_living_birb(), 1)
		add_attack(preload("res://scenes/Attacks/Attack_Basic_Robin.tscn"), 1, random_living_birb(), 1)
		add_attack(preload("res://scenes/Attacks/Attack_Basic_Robin.tscn"), 1, random_living_birb(), 1)
		add_attack(preload("res://scenes/Attacks/Attack_Basic_Robin.tscn"), 1, random_living_birb(), 1) 
	elif a == 5:
		add_attack(preload("res://scenes/Attacks/Attack_Stun_Trash.tscn"), 1, random_living_birb(), 2)
		add_attack(preload("res://scenes/Attacks/Attack_Stun_Trash.tscn"), 1, random_living_birb(), 2)
	elif a == 6:
		add_action(preload("res://scenes/Attacks/Enemy_Volley.tscn"), [1, random_living_birb(), 6])
	elif a == 7:
		add_attack(preload("res://scenes/Attacks/Attack_Stun_Trash.tscn"), 1, random_living_birb(), 4)
		add_action(preload("res://scenes/Attacks/Enemy_Guard.tscn"), [1, 4])
	else:
		add_attack(preload("res://scenes/Attacks/Attack_Basic_Robin.tscn"), 1, random_living_birb(), 1)
		add_attack(preload("res://scenes/Attacks/Attack_Basic_Robin.tscn"), 1, random_living_birb(), 2)
		add_attack(preload("res://scenes/Attacks/Attack_Basic_Robin.tscn"), 1, random_living_birb(), 3)
		add_attack(preload("res://scenes/Attacks/Attack_Basic_Robin.tscn"), 1, random_living_birb(), 4)

func ai_dinosaur_peacock(a):
	if a == 0:
		add_action(preload("res://scenes/Attacks/Enemy_Guard.tscn"), [2, 3])
	elif a == 1:
		var target = -1
		var damage = 3
		for i in [0, 1, 3]:
			if enemies[i].hp > 0 and enemies[i].max_hp - enemies[i].hp > damage:
				damage = enemies[i].max_hp - enemies[i].hp 
				target = i
		if target != -1:
			add_action(preload("res://scenes/Attacks/Enemy_Mists.tscn"), [2, target, 3])
		else:
			add_attack(preload("res://scenes/Attacks/Attack_Stun_Stone.tscn"), 2, random_living_birb(), 2)
	elif a == 2:
		add_attack(preload("res://scenes/Attacks/Attack_Freeze.tscn"), 2, random_living_birb(), 2) 
	elif a == 3:
		add_attack(preload("res://scenes/Attacks/Attack_Fires.tscn"), 2, random_living_birb(), 2) 
	elif a == 4:
		add_attack(preload("res://scenes/Attacks/Attack_Confuse_Plasma.tscn"), 2, random_living_birb(), 4) 
	elif a == 5:
		add_attack(preload("res://scenes/Attacks/Attack_Freeze.tscn"), 2, random_living_birb(), 4)       
	elif a == 6:
		add_attack(preload("res://scenes/Attacks/Attack_Fires.tscn"), 2, random_living_birb(), 3)
	elif a == 7:
		add_attack(preload("res://scenes/Attacks/Attack_Confuse_Plasma.tscn"), 2, random_living_birb(), 3) 
		add_attack(preload("res://scenes/Attacks/Attack_Confuse_Plasma.tscn"), 2, random_living_birb(), 3) 
	else:
		add_attack(preload("res://scenes/Attacks/Attack_Stun_Stone.tscn"), 2, random_living_birb(), 1)
		add_attack(preload("res://scenes/Attacks/Attack_Confuse_Plasma.tscn"), 2, random_living_birb(), 2) 
		add_attack(preload("res://scenes/Attacks/Attack_Fires.tscn"), 2, random_living_birb(), 2)
		add_attack(preload("res://scenes/Attacks/Attack_Freeze.tscn"), 2, random_living_birb(), 2) 
		
func ai_dinosaur_swan(a):
	if a == 0:
		add_action(preload("res://scenes/Attacks/Enemy_Guard.tscn"), [3, 3])
	elif a == 1:
		var s = 0
		for i in range(3):
			if enemies[i].hp > 0:
				s += min(enemies[i].max_hp - enemies[i].hp, 2)
		if s >= 4:
			add_action(preload("res://scenes/Attacks/Enemy_Blood_Rite.tscn"), [3, 2])
		else:
			add_attack(preload("res://scenes/Attacks/Attack_Kneecap.tscn"), 3, random_living_birb(), 1) 
	elif a == 2:
		add_attack(preload("res://scenes/Attacks/Attack_Extort_Swan.tscn"), 3, random_living_birb(), 2) 
	elif a == 3:
		add_attack(preload("res://scenes/Attacks/Attack_Dinocurse.tscn"), 3, random_living_birb(), 2) 
	elif a == 4:
		add_attack(preload("res://scenes/Attacks/Attack_Deathspike.tscn"), 3, random_living_birb(), 2) 
	elif a == 5:
		for i in range(4):
			if birbs[i].hp > 0:
				add_attack(preload("res://scenes/Attacks/Attack_Kneecap.tscn"), 3, i, 1) 
	elif a == 6:
		add_attack(preload("res://scenes/Attacks/Attack_Dinocurse.tscn"), 3, random_living_birb(), 5)  
	elif a == 7:
		add_attack(preload("res://scenes/Attacks/Attack_Extort_Swan.tscn"), 3, random_living_birb(), 6)
	elif a == 8:
		add_attack(preload("res://scenes/Attacks/Attack_Deathspike.tscn"), 3, random_living_birb(), 3)     
		add_attack(preload("res://scenes/Attacks/Attack_Extort_Swan.tscn"), 3, random_living_birb(), 4)

func ai_dinosaurs_easy():
	var contempt = [0, 0, 0, 0]
	for i in range(helpers.rand_choice([6, 7, 8])):
		var a = random_living_enemy()
		contempt[a] = contempt[a] + 1

	if enemies[0].hp > 0 and enemies[0].effects["hustle"] > 0:
		enemies[0].effects["hustle"] = 0
		ai_dinosaur_hawk(3)
	if enemies[1].hp > 0 and enemies[1].effects["hustle"] > 0:
		enemies[1].effects["hustle"] = 0
		ai_dinosaur_finch(3)
	if enemies[2].hp > 0 and enemies[2].effects["hustle"] > 0:
		enemies[2].effects["hustle"] = 0
		ai_dinosaur_peacock(3)
	if enemies[3].hp > 0 and enemies[3].effects["hustle"] > 0:
		enemies[3].effects["hustle"] = 0
		ai_dinosaur_swan(3)

	if enemies[0].hp > 0:
		ai_dinosaur_hawk(contempt[0])
	if enemies[1].hp > 0:
		ai_dinosaur_finch(contempt[1])
	if enemies[2].hp > 0:
		ai_dinosaur_peacock(contempt[2])
	if enemies[3].hp > 0:
		ai_dinosaur_swan(contempt[3])

func ai_goose():
	for i in range(4):
		if birbs[i].effects["shattered"] > 0:
			add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 0, i, 4)
			break
	if len(enemies[0].attacks) == 0:
		if turn_count % 3 == 0 or turn_count % 3 == 1:
			for i in range(3):
				if birbs[i].hp > 0:
					add_attack(preload("res://scenes/Attacks/Attack_Kneecap.tscn"), 0, i, 1) 
		else:
			add_action(preload("res://scenes/Attacks/Enemy_Volley.tscn"), [0, random_living_birb(), 4])

	   
func ai_duck():
	var swan = 3
	var other_birb = -1
	for i in range(3):
		if birbs[i].hp > 0:
			other_birb = i
	if birbs[3].hp <= 0:
		damage_enemy(-1, 0, 2)
		add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 0, other_birb, helpers.rand_choice([4,5,6]))
	elif enemies[0].hp > 2 * enemies[0].max_hp / 3:
		add_attack(preload("res://scenes/Attacks/Attack_Flirt.tscn"), 0, swan, helpers.rand_choice([3,4]))
	elif enemies[0].hp > enemies[0].max_hp / 3:
		add_attack(preload("res://scenes/Attacks/Attack_Flirt.tscn"), 0, swan, helpers.rand_choice([1,2,3]))
		add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 0, other_birb, helpers.rand_choice([1,2,3]))
	else:
		add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 0, other_birb, helpers.rand_choice([3,4,5]))

func add_to_hand(pos, scene):
	var c = scene.instance()
	add_child(c)
	hand[pos] = c
	c.position = Vector2(-1000,-1000)
	
func deck_append(scene):
	var c = scene.instance()
	add_child(c)
	deck.append(c)
	c.visible = false

func del_hand():
	for i in range(7):
		if hand[i]:
			hand[i].queue_free()
			hand[i] = null

func script_tutorial_1():
	if turn_count == 1:
		deck = []
		del_hand()
		for i in range(15):
			deck_append(preload("res://scenes/Cards/Card_Peck.tscn"))
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
	if turn_count == 2:
		deck = []
		del_hand()
		for i in range(12):
			deck_append(preload("res://scenes/Cards/Card_Peck.tscn"))
		deck_append(preload("res://scenes/Cards/Card_Guard.tscn"))
		deck_append(preload("res://scenes/Cards/Card_Peck.tscn"))
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 0, 1, 7)
		add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 1, 1, 6)
		add_action(preload("res://scenes/Attacks/Enemy_Guard.tscn"), [1, 3])
	if turn_count == 3:
		deck = []
		del_hand()
		for i in range(6):
			deck_append(preload("res://scenes/Cards/Card_Peck.tscn"))
		deck_append(preload("res://scenes/Cards/Card_Shield.tscn"))
		deck_append(preload("res://scenes/Cards/Card_Peck.tscn"))
		deck_append(preload("res://scenes/Cards/Card_Sass.tscn")) 
		deck_append(preload("res://scenes/Cards/Card_Guard.tscn")) 
		deck_append(preload("res://scenes/Cards/Card_Swipe.tscn"))
		deck_append(preload("res://scenes/Cards/Card_Peck.tscn"))     
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		times_rewinded = 0
	if turn_count == 4:
		deck = []
		del_hand()
		add_to_hand(0, preload("res://scenes/Cards/Card_Shield.tscn"))
		add_to_hand(1, preload("res://scenes/Cards/Card_Peck.tscn"))
		add_to_hand(2, preload("res://scenes/Cards/Card_Guard.tscn"))
		add_to_hand(4, preload("res://scenes/Cards/Card_Peck.tscn"))
		deck_append(preload("res://scenes/Cards/Card_Guard.tscn")) 
		deck_append(preload("res://scenes/Cards/Card_Claw.tscn")) 
		deck_append(preload("res://scenes/Cards/Card_Guard.tscn")) 
		deck_append(preload("res://scenes/Cards/Card_Swipe.tscn"))
		deck_append(preload("res://scenes/Cards/Card_Peck.tscn")) 
		deck_append(preload("res://scenes/Cards/Card_Sass.tscn"))       
		if enemies[0].hp < 13:
			enemies[0].hp = 13  
		if enemies[1].hp < 13:
			enemies[1].hp = 13 
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 0, 1, 8)
		add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 1, 0, 6) 
		birbs[0].hp = 10
		birbs[1].hp = 5 
		birbs[0].actions = 1
		birbs[1].actions = 1
	if turn_count == 5:
		get_parent().advance_victory()

func script_tutorial_2():
	if turn_count == 1:
		deck = []
		del_hand()
		for i in range(10):
			deck_append(preload("res://scenes/Cards/Card_Peck.tscn"))
		deck_append(preload("res://scenes/Cards/Card_Hex.tscn")) 
		deck_append(preload("res://scenes/Cards/Card_Fires.tscn")) 
		deck_append(preload("res://scenes/Cards/Card_Guard.tscn")) 
		deck_append(preload("res://scenes/Cards/Card_Kneecap.tscn"))
		deck_append(preload("res://scenes/Cards/Card_Shield.tscn")) 
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_attack(preload("res://scenes/Attacks/Attack_Stun_Cannonball.tscn"), 0, 3, 1)
		add_attack(preload("res://scenes/Attacks/Attack_Stun_Cannonball.tscn"), 0, 0, 6) 
		add_attack(preload("res://scenes/Attacks/Attack_Stun_Cannonball.tscn"), 0, 2, 10)
		add_attack(preload("res://scenes/Attacks/Attack_Stun_Cannonball.tscn"), 0, 1, 12) 
		enemies[0].hp = 24
		enemies[1].hp = 0
		enemies[0].effects["aflame"] = 0
		enemies[1].effects["aflame"] = 0
		birbs[0].hp = 10
		birbs[1].hp = 15 
		birbs[2].hp = 12
		birbs[3].hp = 10
		birbs[0].actions = 1
		birbs[1].actions = 1
		birbs[2].actions = 1
		birbs[3].actions = 1
	if turn_count == 2:
		deck = []
		del_hand()
		add_to_hand(3, preload("res://scenes/Cards/Card_Kneecap.tscn"))
		for i in range(5):
			deck_append(preload("res://scenes/Cards/Card_Peck.tscn"))
		deck_append(preload("res://scenes/Cards/Card_Guard.tscn")) 
		deck_append(preload("res://scenes/Cards/Card_Assist.tscn")) 
		deck_append(preload("res://scenes/Cards/Card_Mists.tscn")) 
		deck_append(preload("res://scenes/Cards/Card_Mists.tscn"))
		deck_append(preload("res://scenes/Cards/Card_Mists.tscn")) 
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_action(preload("res://scenes/Attacks/Enemy_Summon_Clones.tscn"), [1, 4])
		add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 0, 3, 10)
		add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 1, 1, 13) 
		enemies[0].hp = 21
		enemies[1].hp = 0
		enemies[0].effects["aflame"] = 2
		enemies[1].effects["aflame"] = 0
		birbs[0].hp = 10
		birbs[1].hp = 9
		birbs[2].hp = 12
		birbs[3].hp = 10
		birbs[0].actions = 1
		birbs[1].actions = 0
		birbs[2].actions = 1
		birbs[3].actions = 1		
	if turn_count == 3:
		deck = []
		del_hand()
		if not hand[2] and not hand[3] and not hand[4]:
			add_to_hand(4, preload("res://scenes/Cards/Card_Mists.tscn"))
		add_to_hand(5, preload("res://scenes/Cards/Card_Kneecap.tscn"))
		deck_append(preload("res://scenes/Cards/Card_Guard.tscn")) 
		deck_append(preload("res://scenes/Cards/Card_Fires.tscn")) 
		deck_append(preload("res://scenes/Cards/Card_Assist.tscn")) 
		deck_append(preload("res://scenes/Cards/Card_Hex.tscn"))
		deck_append(preload("res://scenes/Cards/Card_Claw.tscn")) 
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_suspended_card_back(preload("res://scenes/Animations/Anim_Draw_Card.tscn"), -1)
		add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 0, 2, 30)
		add_attack(preload("res://scenes/Attacks/Attack_Basic.tscn"), 1, 3, 10) 
		enemies[0].hp = 19
		enemies[1].hp = 4
		enemies[0].effects["aflame"] = 1
		enemies[1].effects["aflame"] = 0
		birbs[0].hp = 10
		birbs[1].hp = 2
		birbs[2].hp = 12
		birbs[3].hp = 3
		birbs[0].actions = 1
		birbs[1].actions = 1
		birbs[2].actions = 1
		birbs[3].actions = 1		
	if turn_count == 4:
		get_parent().advance_victory()

func string_to_deck(s, a):
	deck = []
	var tokens = s.split(",",false)
	for token in tokens:
		for card in a:
			var c = card.instance()
			if c.card_name == token and len(deck) < 30:
				deck.append(c)
				add_child(c)
				c.visible = false
	deck.shuffle()
