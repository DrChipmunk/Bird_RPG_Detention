extends AudioStreamPlayer


func _ready():
	pass


func load_and_play(sound):
	stop()
	stream = sound
	seek(0)
	play()
