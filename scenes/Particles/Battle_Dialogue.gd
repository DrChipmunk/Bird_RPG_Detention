extends Node2D

var speaker_pos = Vector2(0, 0)
var lines = 1
var enemy_speaking = false
var lifetime = 3

func _ready():
	pass
	
func _process(delta):
	update_appearance()
	if lifetime > 0:
		lifetime -= delta
		if lifetime <= 0:
			queue_free()

func update_appearance():
	lines = get_node("Text").get_line_count()
	get_node("Rect").margin_top = 0
	get_node("Rect").margin_bottom = max(50, 20 * lines + 10)
	if enemy_speaking:
		get_node("Birb_Arrow").visible = false
		get_node("Enemy_Arrow").visible = true
		position = speaker_pos + Vector2(-202, -24)
	else:
		get_node("Enemy_Arrow").visible = false
		get_node("Birb_Arrow").visible = true
		position = speaker_pos + Vector2(54, -24)
	if position.y + get_node("Rect").margin_bottom > 390:
		get_node("Rect").margin_bottom = 390 - position.y
		get_node("Rect").margin_top = get_node("Rect").margin_bottom - max(50, 20 * lines + 10)
		

func set_text(text):
	get_node("Text").text = text
	update_appearance()
	
func set_speaker_pos(pos):
	speaker_pos = pos
	update_appearance()
	
func set_enemy_speaking(b):
	enemy_speaking = b
	update_appearance()
