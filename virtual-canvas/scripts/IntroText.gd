extends CanvasLayer

# ============================================================
#  IntroText.gd
#  Écran noir avec texte qui s'écrit lettre par lettre
#  Attacher ce script à un nœud CanvasLayer (ou Control)
# ============================================================

# ----- Paramètres personnalisables -----
@export var paragraphs: Array[String] = [
	"Il y a bien longtemps, dans un monde oublié des dieux...",
	"Une guerre sans nom ravagea les terres du nord.",
	"Seul un héros pouvait encore changer le cours du destin.",
	"Ce héros... c'est toi.",
]

@export var chars_per_second: float = 30.0      # Vitesse d'écriture
@export var pause_between: float  = 1.2         # Pause entre paragraphes (secondes)
@export var fade_duration: float  = 0.8         # Durée du fondu d'entrée/sortie
@export var next_scene: String    = "res://scenes//gallery.tscn"  # Scène à charger après l'intro

# ----- Nœuds internes -----
var _background : ColorRect
var _label      : RichTextLabel

# ----- État interne -----
var _para_index : int   = 0
var _char_index : int   = 0
var _full_text  : String = ""
var _timer      : float = 0.0
var _state      : String = "FADE_IN"   # FADE_IN | TYPING | PAUSE | FADE_OUT | DONE
var _alpha      : float = 0.0
var _skip_pressed : bool = false

# ============================================================
func _ready() -> void:
	_build_ui()
	_load_paragraph()

# ============================================================
func _build_ui() -> void:
	# Fond noir plein écran
	_background = ColorRect.new()
	_background.color = Color.BLACK
	_background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_background)

	# Créer le label EN PREMIER
	_label = RichTextLabel.new()
	_label.bbcode_enabled = true
	_label.scroll_active = false
	_label.fit_content = true
	_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	# Positionnement
	_label.set_anchor(SIDE_LEFT,   0.1)
	_label.set_anchor(SIDE_RIGHT,  0.9)
	_label.set_anchor(SIDE_TOP,    0.35)
	_label.set_anchor(SIDE_BOTTOM, 0.65)
	_label.offset_left   = 0
	_label.offset_right  = 0
	_label.offset_top    = 0
	_label.offset_bottom = 0

	# Ajouter à la scène
	add_child(_label)

	# Appliquer le style APRÈS add_child
	var pixel_font = load("res://fonts/PressStart2P-Regular.ttf")
	if pixel_font == null:
		push_error("FONT INTROUVABLE — vérifie le chemin dans res://fonts/")
	else:
		_label.add_theme_font_override("normal_font", pixel_font)
		_label.add_theme_font_size_override("normal_font_size", 14)

	_label.add_theme_color_override("default_color", Color.WHITE)

# ============================================================
func _load_paragraph() -> void:
	_char_index = 0
	_timer      = 0.0
	_label.text = ""

	if _para_index < paragraphs.size():
		_full_text = paragraphs[_para_index]
	else:
		_full_text = ""

# ============================================================
func _process(delta: float) -> void:
	match _state:

		"FADE_IN":
			_alpha = move_toward(_alpha, 1.0, delta / fade_duration)
			_set_alpha(_alpha)
			if _alpha >= 1.0:
				_state = "TYPING"

		"TYPING":
			if _skip_pressed:
				# Affiche tout le paragraphe immédiatement
				_label.text = _full_text
				_char_index  = _full_text.length()
				_skip_pressed = false
				_timer = 0.0
				_state = "PAUSE"
				return

			_timer += delta
			var chars_to_show : int = int(_timer * chars_per_second)
			chars_to_show = min(chars_to_show, _full_text.length())

			if chars_to_show != _char_index:
				_char_index = chars_to_show
				_label.text = _full_text.substr(0, _char_index)

			if _char_index >= _full_text.length():
				_timer = 0.0
				_state = "PAUSE"

		"PAUSE":
			if _skip_pressed:
				_skip_pressed = false
				_advance()
				return

			_timer += delta
			if _timer >= pause_between:
				_advance()

		"FADE_OUT":
			_alpha = move_toward(_alpha, 0.0, delta / fade_duration)
			_set_alpha(_alpha)
			if _alpha <= 0.0:
				_state = "DONE"
				_on_intro_finished()

		"DONE":
			pass

# ============================================================
func _advance() -> void:
	_para_index += 1
	_timer = 0.0

	if _para_index < paragraphs.size():
		_load_paragraph()
		_state = "TYPING"
	else:
		_state = "FADE_OUT"

# ============================================================
func _set_alpha(a: float) -> void:
	_background.modulate.a = a
	_label.modulate.a      = a

# ============================================================
func _input(event: InputEvent) -> void:
	# Espace, Entrée ou clic pour passer
	if _state in ["TYPING", "PAUSE"]:
		if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
			_skip_pressed = true
		elif event is InputEventMouseButton and event.pressed:
			_skip_pressed = true

# ============================================================
func _on_intro_finished() -> void:
	# Change de scène une fois l'intro terminée
	if next_scene != "":
		get_tree().change_scene_to_file(next_scene)
	else:
		queue_free()
