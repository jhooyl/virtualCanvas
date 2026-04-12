extends AudioStreamPlayer

func _ready():
	# On définit la musique ici, elle se lancera au démarrage du JEU
	stream = load("res://assets/music/Evening-Improvisation-with-Ethera(chosic.com).mp3")
	autoplay = true
	bus = "Master"
	play()
	
func _on_finished():
	play() # Relance la musique quand elle se termine
