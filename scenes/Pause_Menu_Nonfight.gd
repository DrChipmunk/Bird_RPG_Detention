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
			if x > 485 and x < 515 and y > 135 and y < 165:
				get_tree().paused = false
				queue_free()
			elif x > 358 and x < 442 and y > 225 and y < 265:
				get_tree().quit()
			elif x > 321 and x < 480 and y > 135 and y < 175:
				other_menu = preload("res://scenes/Save_Menu.tscn").instance()
				add_child(other_menu)

func remove_other_menu():
	other_menu = null
