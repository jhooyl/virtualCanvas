extends CanvasLayer

const DIALOGUES = [
	[
		"Excellent work! You've restored the first painting!",
		"The colors are vivid once more... just like I remember.",
		"Two more to go. I believe in you!"
	],
	[
		"Magnificent! The second masterpiece lives again!",
		"Every piece you place brings the gallery back to life.",
		"One final challenge awaits. Are you ready?"
	],
	[
		"Incredible! You've done it — all three paintings restored!",
		"The gallery shines once more, thanks to you.",
		"You are a true guardian of art. Well done!"
	]
]

@onready var character_sprite: AnimatedSprite2D = $CharacterSprite
@onready var dialogue_box: Panel = $DialogueBox
@onready var dialogue_label: Label = $DialogueBox/DialogueLabel
@onready var continue_label: Label = $DialogueBox/ContinueLabel

var current_dialogue_index := 0
var dialogue_lines: Array = []
var is_animating := false

func _ready():
	var puzzle_index = clamp(PuzzleData.current_index - 1, 0, DIALOGUES.size() - 1)
	dialogue_lines = DIALOGUES[puzzle_index]

	dialogue_box.modulate.a = 0
	character_sprite.modulate.a = 0

	# ✅ Applique ta police sur le label (remplace par ton vrai nom de fichier)
	var font = load("res://fonts/PressStart2P-Regular.ttf")
	dialogue_label.add_theme_font_override("font", font)
	dialogue_label.add_theme_font_size_override("font_size", 15)
	continue_label.add_theme_font_override("font", font)
	continue_label.add_theme_font_size_override("font_size", 12)

	# ✅ Lance idle en boucle dès le début
	character_sprite.sprite_frames.set_animation_loop("idle", true)
	character_sprite.play("idle")

	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(character_sprite, "modulate:a", 1.0, 0.6)
	tween.tween_property(dialogue_box, "modulate:a", 1.0, 0.4)
	tween.tween_callback(_show_next_line)

func _show_next_line():
	if current_dialogue_index >= dialogue_lines.size():
		_end_dialogue()
		return

	continue_label.visible = false
	is_animating = true
	dialogue_label.text = ""

	var full_text = dialogue_lines[current_dialogue_index]
	for i in range(full_text.length()):
		dialogue_label.text = full_text.substr(0, i + 1)
		await get_tree().create_timer(0.03).timeout

	is_animating = false
	continue_label.visible = true

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed):
		if is_animating:
			dialogue_label.text = dialogue_lines[current_dialogue_index]
			is_animating = false
			continue_label.visible = true
		else:
			current_dialogue_index += 1
			_show_next_line()

func _end_dialogue():
	# ✅ idle continue de jouer en boucle, pas besoin de le relancer
	continue_label.text = "[ Press any key to continue... ]"
	continue_label.visible = true

	await get_tree().create_timer(0.5).timeout
	set_process_input(false)
	await get_tree().create_timer(1.0).timeout

	PuzzleData.next_puzzle()
	if PuzzleData.is_finished():
		get_tree().change_scene_to_file("res://scenes/broken_gallery.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/MainPuzzle.tscn")
