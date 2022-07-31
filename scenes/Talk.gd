extends Node2D

var birds = {}

var left_birds = []
var right_birds = []

var lines = []
var curr_line = 0

func location(line):
	var st = line.split(" ")[1]
	get_node("Background").texture = load("res://sprites/" + st)
	
func dramatis_personae(cast):
	cast = cast.replace("Dramatis Personae: ", "")
	for bird in cast.split(" "):
		var b = preload("res://scenes/Talk_Bird.tscn").instance()
		b.set_bird(bird)
		birds[bird] = b
		add_child(b)

func bird_positions():
	for bird in birds:
		if bird in left_birds:
			birds[bird].set_centre_pos(350 - 400.0 * (left_birds.find(bird) + 1) / (len(left_birds) + 1))
			birds[bird].z_index = left_birds.find(bird)
		elif bird in right_birds:
			birds[bird].set_centre_pos(450 + 400.0 * (right_birds.find(bird) + 1) / (len(right_birds) + 1))
			birds[bird].z_index = right_birds.find(bird)
		else:
			if birds[bird].target_x < 400:
				birds[bird].target_x = -200
			else:
				birds[bird].target_x = 1000

func execute_line():
	if curr_line >= len(lines):
		get_parent().advance()
		return
	var line = lines[curr_line]
	var speaker = line.split(":")[0]
	var text = line.split(":")[1].strip_edges()
	if speaker == "L":
		left_birds = []
		for bird in text.split(" "):
			var mode = ""
			if "(" in bird:
				mode = bird.split("(")[1].replace(")","").strip_edges()
				bird = bird.split("(")[0]
			if not "!" in bird:
				left_birds.append(bird)
			bird = bird.replace("!", "")
			if not bird in birds:
				var b = preload("res://scenes/Talk_Bird.tscn").instance()
				b.set_bird(bird)
				birds[bird] = b
				add_child(b)
			birds[bird].move_mode = mode
		bird_positions()
		curr_line += 1
		execute_line()
	elif speaker == "R":
		right_birds = []
		for bird in text.split(" "):
			var mode = ""
			if "(" in bird:
				mode = bird.split("(")[1].replace(")","").strip_edges()
				bird = bird.split("(")[0]
			if not "!" in bird:
				right_birds.append(bird)
			bird = bird.replace("!", "")
			if not bird in birds:
				var b = preload("res://scenes/Talk_Bird.tscn").instance()
				b.set_bird(bird)
				birds[bird] = b
				add_child(b)
			birds[bird].move_mode = mode
		bird_positions()
		curr_line += 1
		execute_line()
	else:
		if speaker == "N":
			get_node("UI/Speaker/Label").text = ""
		else:
			get_node("UI/Speaker/Label").text = speaker.replace("_", " ")
		get_node("UI/Textbox/Label").text = text
		for bird in birds:
			if bird == speaker:
				birds[bird].set_foreground(true)
			else:
				birds[bird].set_foreground(false)

func _ready():
	pass

func load_script(script):
	var file = File.new()
	file.open("res://scripts/" + script, File.READ)
	var content = file.get_as_text()
	file.close()
	for line in content.split("\n"):
		if line.begins_with("Location:"):
			location(line)
		elif line.begins_with("Dramatis Personae:"):
			dramatis_personae(line)
		elif len(line) > 0 and not line.begins_with("#"):
			lines.append(line)
	bird_positions()
	execute_line()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if event.position.x > 700 and event.position.y > 550:
				var m = preload("res://scenes/Pause_Menu_Nonfight.tscn").instance()
				add_child(m)
				get_tree().paused = true
			else:
				curr_line += 1
				execute_line()
	
