extends Node

# On crée une variable "exportée" qui apparaîtra dans l'inspecteur
@export_file("*.mp3", "*.ogg", "*.wav") var music_to_play: String

func _ready():
	if music_to_play != "":
		# On appelle notre Singleton avec la musique choisie pour CETTE scène
		MusicPlayer.play_music(music_to_play)
	else:
		push_warning("MusicZone : Aucune musique n'a été sélectionnée dans l'inspecteur !")
