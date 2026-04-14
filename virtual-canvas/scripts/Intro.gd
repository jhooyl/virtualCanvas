extends Node2D

@onready var label = $Label
@onready var music = $AudioStreamPlayer
@onready var color_rect = $ColorRect

var lines = [
	"An art student set out to visit a gallery,
	 
	hoping to find inspiration for his work.",
	"It was known as a quiet place, 
	
	filled with classical paintings and forgotten artists.",
	"Nothing unusual. Nothing to worry about.",
    "Just another gallery… or so it seemed."
]

var typing_speed = 0.06

func _ready():
	music.play()
	await play_intro()

func play_intro():
	for i in range(lines.size()):
		await show_line(lines[i])
		await get_tree().create_timer(1.8).timeout # pause entre phrases
	
	await last_effect()

func show_line(text):
	label.text = ""
	
	# Apparition lettre par lettre
	for i in range(text.length()):
		label.text += text[i]
		await get_tree().create_timer(typing_speed).timeout
	
	# Reste affiché
	await get_tree().create_timer(1.5).timeout
	
	# Disparition (fade out)
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 1.0)
	await tween.finished
	
	label.text = ""
	label.modulate.a = 1.0 # reset pour la prochaine phrase

func last_effect():
	# flash blanc
	var tween = create_tween()
	tween.tween_property(color_rect, "color", Color(1,1,1), 1.2)
	await tween.finished

	# transition vers la galerie
	get_tree().change_scene_to_file("res://scenes/gallery.tscn")
