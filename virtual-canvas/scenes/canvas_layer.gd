extends CanvasLayer

# Référence aux labels
@onready var dialogue_text = $DialogueText
@onready var speaker_name = $SpeakerName

# Variables pour le dialogue
var dialogues = []
var current_index = 0
var is_active = false
var callback_on_end = null  # Optionnel : fonction à appeler à la fin du dialogue

# Fonction pour lancer le dialogue
func start_dialogue(dialogue_array, _callback_on_end = null):
	dialogues = dialogue_array
	current_index = 0
	is_active = true
	callback_on_end = _callback_on_end
	show()
	display_line()

# Affiche la ligne actuelle
func display_line():
	if current_index >= dialogues.size():
		end_dialogue()
		return

	var line = dialogues[current_index]
	dialogue_text.text = line["text"]
	speaker_name.text = line["speaker"]

# Passe à la ligne suivante
func next_line():
	if not is_active:
		return
	
	current_index += 1
	display_line()

# Fin du dialogue
func end_dialogue():
	is_active = false
	hide()
	if callback_on_end != null:
		callback_on_end.call_func()

# Entrée clavier pour passer les lignes
func _input(event):
	if is_active and event.is_action_pressed("ui_accept"):
		next_line()
