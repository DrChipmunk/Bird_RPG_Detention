extends Node2D

var duration = 0.55
var elapsed = 0
var fight

var helpers = preload("res://scenes/Helpers.gd")

func _ready():
	fight = get_parent()

func resolve(active, target):
	pass

func animate(delta):
	elapsed += delta
	if helpers.this_frame(0.05, elapsed, delta):
		get_node("Sound_Effect_Player").load_and_play(preload("res://sounds/rewind_effect-001.wav"))
		var p = preload("res://scenes/Particles/Particle_Rewind_Wipe.tscn").instance()
		get_parent().add_child(p)
	if helpers.this_frame(0.5, elapsed, delta):
		get_parent().times_rewinded += 1
		var talker = get_parent().random_living_birb()
		var text = ["We can do it!",
			"Let's try that again.",
			"Maybe if we tried...",
			"Really?"
		][talker]
		if get_parent().times_rewinded in [2,3]:
			if get_parent().scene == "tutorial_1":
				talker = 1
				text = "I can shield you better than I can defend myself."
			elif get_parent().scene == "tutorial_2" and get_parent().turn_count == 1:
				talker = 1
				text = "I think I have to get hit here"				
			elif get_parent().scene == "tutorial_2" and get_parent().turn_count == 2:
				talker = 0
				text = "Can I help with the healing?"				
			elif get_parent().scene == "tutorial_2" and get_parent().turn_count == 3:
				talker = 3
				text = "What if we just killed her?"				
		if get_parent().times_rewinded > 3:
			if get_parent().scene == "tutorial_1":
				talker = 0
				text = "I can take the hit! Let me Claw them!"			
			elif get_parent().scene == "tutorial_2" and get_parent().turn_count == 1:
				talker = 3
				text = "Half of 1 is 0."				
			elif get_parent().scene == "tutorial_2" and get_parent().turn_count == 2:
				talker = 2
				text = "I need to heal Finch twice."				
			elif get_parent().scene == "tutorial_2" and get_parent().turn_count == 3:
				talker = 2
				text = "She'll take fire damage before she has a chance to attack."				
		var p = preload("res://scenes/Particles/Battle_Dialogue.tscn").instance()
		p.set_enemy_speaking(false)
		p.set_text(text)
		p.set_speaker_pos(helpers.default_birb_pos(talker))
		get_parent().add_child(p)
	return elapsed >= duration
