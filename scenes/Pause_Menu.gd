extends Node2D

var elapsed = 0
var other_menu = null

func _ready():
	pass

func _process(delta):
	elapsed += delta
	if elapsed < 0.3:
		get_node("Sprite").position.y = 124 + 700 * (0.3 - elapsed) * (0.3 - elapsed) / 0.09
	else:
		get_node("Sprite").position.y = 124

		
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and elapsed > 0.3 and not other_menu:
			var x = event.position.x
			var y = event.position.y
			if x > 471 and x < 501 and y > 135 and y < 165:
				get_tree().paused = false
				queue_free()
			elif x > 358 and x < 442 and y > 270 and y < 310:
				get_tree().quit()
			elif x > 334 and x < 466 and y > 135 and y < 175 and not get_parent().scene in ["tutorial_1", "tutorial_2"]:
				get_tree().paused = false
				queue_free()
				get_parent().concede()
			elif x > 321 and x < 480 and y > 180 and y < 220:
				other_menu = preload("res://scenes/Save_Menu.tscn").instance()
				add_child(other_menu)

func remove_other_menu():
	other_menu = null
