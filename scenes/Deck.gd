extends Node2D

var card_plates
var tabs
var fight_button
var deck_label
var counts
var decklist

var deck
var current_tab
var available_cards

onready var sound_effect_player = get_node("Sound_Effect_Player")

var tab_textures_off = [
	preload("res://sprites/tab_neutral_off.png"),
	preload("res://sprites/tab_hawk_off.png"),
	preload("res://sprites/tab_finch_off.png"),
	preload("res://sprites/tab_peacock_off.png"),
	preload("res://sprites/tab_swan_off.png"),
	preload("res://sprites/tab_multiple_off.png")
]

var tab_textures_on = [
	preload("res://sprites/tab_neutral_on.png"),
	preload("res://sprites/tab_hawk_on.png"),
	preload("res://sprites/tab_finch_on.png"),
	preload("res://sprites/tab_peacock_on.png"),
	preload("res://sprites/tab_swan_on.png"),
	preload("res://sprites/tab_multiple_on.png")
]

func _ready():
	card_plates = []
	for i in range(6):
		card_plates.append(get_node("Card_Plate_" + str(i + 1)))
	tabs = []
	for i in range(6):
		tabs.append(get_node("Tab_" + str(i + 1)))
	fight_button = get_node("Start_Fight")
	deck_label = get_node("Deck_Label")
	counts = []
	for i in range(6):
		card_plates.append(get_node("Count_" + str(i + 1)))
	decklist = []
	for i in range(30):
		decklist.append(get_node("Decklist_" + str(i + 1)))
	deck = []
	current_tab = 0
	available_cards = [[], [], [], [], [], []]
	
func setup_available_cards(scene, choices):
	available_cards = [[], [], [], [], [], []]
	
	available_cards[0].append(preload("res://scenes/Cards/Card_Peck.tscn"))
	available_cards[0].append(preload("res://scenes/Cards/Card_Guard.tscn"))
	available_cards[0].append(preload("res://scenes/Cards/Card_Assist.tscn"))
	
	available_cards[1].append(preload("res://scenes/Cards/Card_Swipe.tscn"))
	available_cards[1].append(preload("res://scenes/Cards/Card_Claw.tscn"))
	
	available_cards[2].append(preload("res://scenes/Cards/Card_Shield.tscn"))
	available_cards[2].append(preload("res://scenes/Cards/Card_Sass.tscn"))
	
	available_cards[3].append(preload("res://scenes/Cards/Card_Mists.tscn"))
	available_cards[3].append(preload("res://scenes/Cards/Card_Fires.tscn"))
	
	available_cards[4].append(preload("res://scenes/Cards/Card_Hex.tscn"))
	available_cards[4].append(preload("res://scenes/Cards/Card_Kneecap.tscn"))

	if scene == "magpie":
		return
		
	available_cards[0].append(preload("res://scenes/Cards/Card_Panic.tscn"))	
	available_cards[1].append(preload("res://scenes/Cards/Card_Hustle.tscn"))
	available_cards[2].append(preload("res://scenes/Cards/Card_Volley.tscn"))
	available_cards[3].append(preload("res://scenes/Cards/Card_Winds.tscn"))
	available_cards[4].append(preload("res://scenes/Cards/Card_Blood_Rite.tscn"))
	
	if scene == "jocks":
		return
		
	available_cards[0].append(preload("res://scenes/Cards/Card_Prepare.tscn"))	
	available_cards[1].append(preload("res://scenes/Cards/Card_Rage.tscn"))
	available_cards[2].append(preload("res://scenes/Cards/Card_Improvise.tscn"))
	available_cards[3].append(preload("res://scenes/Cards/Card_Freeze.tscn"))
	available_cards[4].append(preload("res://scenes/Cards/Card_Extort.tscn"))		

	if scene == "fangirls":
		return
		
	available_cards[0].append(preload("res://scenes/Cards/Card_Heroics.tscn"))	
	available_cards[1].append(preload("res://scenes/Cards/Card_Gains.tscn"))
	available_cards[2].append(preload("res://scenes/Cards/Card_Taunt.tscn"))
	available_cards[3].append(preload("res://scenes/Cards/Card_Spark.tscn"))
	available_cards[4].append(preload("res://scenes/Cards/Card_Nevermore.tscn"))		
	
	if scene == "peep":
		return
		
	if choices["finch"] == "spotlight":
		available_cards[2].append(preload("res://scenes/Cards/Card_Spotlight.tscn"))
	if choices["finch"] == "solo":
		available_cards[2].append(preload("res://scenes/Cards/Card_Solo.tscn"))
		
	if scene == "pidgeons":
		return
		
	if choices["hawk"] == "bodyslam":
		available_cards[1].append(preload("res://scenes/Cards/Card_Bodyslam.tscn"))
	if choices["hawk"] == "soulflame":
		available_cards[1].append(preload("res://scenes/Cards/Card_Soulflame.tscn"))

	if choices["pairing"] == "ry":
		available_cards[5].append(preload("res://scenes/Cards/Card_Fortify.tscn"))		
		available_cards[5].append(preload("res://scenes/Cards/Card_Parry.tscn"))
		available_cards[5].append(preload("res://scenes/Cards/Card_Yell.tscn"))
	if choices["pairing"] == "rg":
		available_cards[5].append(preload("res://scenes/Cards/Card_Focus.tscn"))		
		available_cards[5].append(preload("res://scenes/Cards/Card_Quake.tscn"))
		available_cards[5].append(preload("res://scenes/Cards/Card_Savant.tscn"))
	if choices["pairing"] == "yg":
		available_cards[5].append(preload("res://scenes/Cards/Card_Lights.tscn"))		
		available_cards[5].append(preload("res://scenes/Cards/Card_Missile.tscn"))
		available_cards[5].append(preload("res://scenes/Cards/Card_Purify.tscn"))
	
	if scene == "goose":
		if choices["pairing"] == "ry":
			available_cards[3] = []
			available_cards[4] = []
		if choices["pairing"] == "rg":
			available_cards[2] = []
			available_cards[4] = []
		if choices["pairing"] == "yg":
			available_cards[1] = []
			available_cards[4] = []
		return
	
	if scene == "duck":
		available_cards[5] = []
		
	if choices["pairing"] == "ry":
		available_cards[5].append(preload("res://scenes/Cards/Card_Self_Care.tscn"))		
		available_cards[5].append(preload("res://scenes/Cards/Card_Thorns.tscn"))
		available_cards[5].append(preload("res://scenes/Cards/Card_Unravel.tscn"))
	if choices["pairing"] == "rg":
		available_cards[5].append(preload("res://scenes/Cards/Card_Aegis.tscn"))		
		available_cards[5].append(preload("res://scenes/Cards/Card_Doomsday.tscn"))
		available_cards[5].append(preload("res://scenes/Cards/Card_Revenge.tscn"))
	if choices["pairing"] == "yg":
		available_cards[5].append(preload("res://scenes/Cards/Card_Headcrack.tscn"))		
		available_cards[5].append(preload("res://scenes/Cards/Card_Fangs.tscn"))
		available_cards[5].append(preload("res://scenes/Cards/Card_Terrify.tscn"))		

	if scene == "duck":
		if choices["pairing"] == "ry":
			available_cards[1] = []
			available_cards[2] = []
		if choices["pairing"] == "rg":
			available_cards[1] = []
			available_cards[3] = []
		if choices["pairing"] == "yg":
			available_cards[2] = []
			available_cards[3] = []
		return
		
	if scene == "swanmother":
		return
		
	if choices["swan"] == "lifeline":
		available_cards[4].append(preload("res://scenes/Cards/Card_Lifeline.tscn"))
	if choices["swan"] == "deathspike":
		available_cards[4].append(preload("res://scenes/Cards/Card_Deathspike.tscn"))	

	if scene == "chickens":
		return
		
	if choices["peacock"] == "channel":
		available_cards[3].append(preload("res://scenes/Cards/Card_Channel.tscn"))
	if choices["peacock"] == "radiance":
		available_cards[3].append(preload("res://scenes/Cards/Card_Radiance.tscn"))	

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if event.position.x < 600 and event.position.y < 100:
				var tab = int(event.position.x / 100)
				if len(available_cards[tab]) > 0:
					current_tab = tab
					update_appearances()
					sound_effect_player.load_and_play(preload("res://sounds/click_neutral-001.wav"))
			if event.position.x < 600 and event.position.y > 100:
				var card_ind = int(event.position.x / 200)
				var rel_x = event.position.x - card_ind * 200
				var rel_y = event.position.y - 100
				if event.position.y > 350:
					card_ind += 3
					rel_y -= 250
				if rel_x > 100 and rel_y < 200:
					var count = 0
					for card in deck:
						if card.card_name == available_cards[current_tab][card_ind].instance().card_name:
							count += 1	
					if rel_y < 100:
						if count < 3 and len(deck) < 30:
							deck.append(available_cards[current_tab][card_ind].instance())
							deck.sort_custom(DeckSorter, "sort_orthographic")
							update_appearances()
							sound_effect_player.load_and_play(preload("res://sounds/click_neutral-001.wav"))
					else:
						if count > 0:
							var name = available_cards[current_tab][card_ind].instance().card_name
							for k in range(len(deck)):
								if deck[k].card_name == name:
									deck.remove(k)
									break
							update_appearances()
							sound_effect_player.load_and_play(preload("res://sounds/click_neutral-001.wav"))
			if event.position.x > 600 and event.position.y < 100:
				if event.position.y > 55 and event.position.x > 655:
					if event.position.y < 95 and event.position.x < 745:
						if len(deck) == 30:
							get_parent().advance()
							sound_effect_player.load_and_play(preload("res://sounds/click_positive-003.wav"))
				if event.position.x > 655 and event.position.x < 745 and event.position.y < 50:
					var m = preload("res://scenes/Pause_Menu_Nonfight.tscn").instance()
					add_child(m)
					get_tree().paused = true
							



class DeckSorter:
	
	static func sort_orthographic(a, b):
		var decklist_letters = {
			"any": "a",
			"hawk": "b",
			"finch": "c",
			"peacock": "d",
			"swan": "e",
			"hawk_finch": "f",
			"hawk_peacock": "g",
			"hawk_swan": "h",
			"finch_peacock": "i",
			"finch_swan": "j",
			"peacock_swan": "k"
		}
		if decklist_letters[a.type] + a.name < decklist_letters[b.type] + b.name:
			return true
		return false
				
					
func update_appearances():
	for i in range(6):
		if i == current_tab:
			tabs[i].visible = true
			tabs[i].texture = tab_textures_on[i]
		elif len(available_cards[i]) > 0:
			tabs[i].visible = true
			tabs[i].texture = tab_textures_off[i]
		else:
			tabs[i].visible = false
	for i in range(6):
		if i >= len(available_cards[current_tab]):
			card_plates[i].visible = false
		else:
			card_plates[i].visible = true
			card_plates[i].get_node("Card").texture = available_cards[current_tab][i].instance().texture
			var count = 0
			for card in deck:
				if card.card_name == available_cards[current_tab][i].instance().card_name:
					count += 1
			if count < 3 and len(deck) < 30:
				card_plates[i].get_node("Plus").texture = preload("res://sprites/button_plus_on.png")
			else:
				card_plates[i].get_node("Plus").texture = preload("res://sprites/button_plus_off.png")
			if count > 0:
				card_plates[i].get_node("Minus").texture = preload("res://sprites/button_minus_on.png")
			else:
				card_plates[i].get_node("Minus").texture = preload("res://sprites/button_minus_off.png")
			for k in range(3):
				if count > k:
					card_plates[i].get_node("Light_" + str(k + 1)).texture = preload("res://sprites/card_light_lit.png")
				else:
					card_plates[i].get_node("Light_" + str(k + 1)).texture = preload("res://sprites/card_light_unlit.png")		
	if len(deck) == 30:
		get_node("Start_Fight").texture = preload("res://sprites/button_fight.png")
	else:
		get_node("Start_Fight").texture = preload("res://sprites/button_fight_off.png")		
	get_node("Deck_Label").text = str(len(deck)) + " / 30"
	var tab_counts = [0, 0, 0, 0, 0, 0]
	for card in deck:
		if card.type == "any":
			tab_counts[0] += 1
		elif card.type == "hawk":
			tab_counts[1] += 1
		elif card.type == "finch":
			tab_counts[2] += 1
		elif card.type == "peacock":
			tab_counts[3] += 1
		elif card.type == "swan":
			tab_counts[4] += 1
		else:
			tab_counts[5] += 1
	for i in range(6):
		if len(available_cards[i]) == 0:
			get_node("Count_" + str(i + 1)).visible = false
		else:
			get_node("Count_" + str(i + 1)).visible = true
			get_node("Count_" + str(i + 1) + "/Label").text = str(tab_counts[i])
	var k = 1
	var decklist_textures = {
		"any": preload("res://sprites/decklist_card_neutral.png"),
		"hawk": preload("res://sprites/decklist_card_hawk.png"),
		"finch": preload("res://sprites/decklist_card_finch.png"),
		"peacock": preload("res://sprites/decklist_card_peacock.png"),
		"swan": preload("res://sprites/decklist_card_swan.png"),
		"hawk_finch": preload("res://sprites/decklist_card_hawk_finch.png"),
		"hawk_peacock": preload("res://sprites/decklist_card_hawk_peacock.png"),
		"hawk_swan": preload("res://sprites/decklist_card_hawk_swan.png"),
		"finch_peacock": preload("res://sprites/decklist_card_finch_peacock.png"),
		"finch_swan": preload("res://sprites/decklist_card_finch_swan.png"),
		"peacock_swan": preload("res://sprites/decklist_card_peacock_swan.png")
	}
	for card in deck:
		get_node("Decklist_" + str(k)).visible = true
		get_node("Decklist_" + str(k)).texture = decklist_textures[card.type]
		get_node("Decklist_" + str(k) + "/Label").text = card.card_name
		k += 1
	while true:
		if k > 30:
			break
		get_node("Decklist_" + str(k)).visible = false
		k += 1

func get_available_cards():
	var a = []
	for tab in available_cards:
		for card in tab:
			a.append(card)
	return a
	
func deck_to_string():
	var s = ""
	for card in deck:
		s = s + card.card_name + ","
	return s
	
func string_to_deck(s):
	var tokens = s.split(",",false)
	var a = get_available_cards()
	for token in tokens:
		for card in a:
			var c = card.instance()
			if c.card_name == token and len(deck) < 30:
				deck.append(c)
				break
	deck.sort_custom(DeckSorter, "sort_orthographic")
	update_appearances()
