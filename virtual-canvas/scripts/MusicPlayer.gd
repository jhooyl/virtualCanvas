extends AudioStreamPlayer

func _ready():
	# On définit la musique ici, elle se lancera au démarrage du JEU
	stream = load("res://assets/music/Evening-Improvisation-with-Ethera(chosic.com).mp3")
	autoplay = true
	bus = "Master"
	play()

func play_music(music_path: String):
	# On vérifie si la musique demandée est déjà en train de jouer
	if stream and stream.resource_path == music_path:
		return 
	
	# Sinon, on charge la nouvelle et on la joue
	stream = load(music_path)
	play()
	
func _on_finished():
	play() # Relance la musique quand elle se termine
