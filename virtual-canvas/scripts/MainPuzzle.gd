extends Node2D

@onready var dialogue = $CanvasLayer  # CanvasLayer est enfant direct de Node2D

# Dialogue de début
var full_dialogue = [
	{"speaker": "Guide", "text": "Bonjour, et bienvenue dans cette galerie."},
	{"speaker": "Guide", "text": "Chaque œuvre ici raconte une histoire."},
	{"speaker": "Étudiante", "text": "Elles sont magnifiques…"},
	{"speaker": "Guide", "text": "Mais certaines sont… fragiles."},
	{"speaker": "Étudiante", "text": "Fragiles ?"},
	{"speaker": "Guide", "text": "Ne touchez pas les œuvres, s’il vous plaît."},
	{"speaker": "Étudiante", "text": "Ce tableau… il est étrange…"},
	{"speaker": "Guide", "text": "Attendez— ne le touchez pas !"},
	{"speaker": "Étudiante", "text": "..."},
	{"speaker": "Étudiante", "text": "*touche le tableau*"},
	{"speaker": "Étudiante", "text": "Quoi— ?!"},
	{"speaker": "SYSTEM", "text": "*BRUIT DE FISSURE*"},
	{"speaker": "SYSTEM", "text": "*TREMBLEMENT*"},
	{"speaker": "SYSTEM", "text": "*VERRE QUI SE BRISE*"},
	{"speaker": "Étudiante", "text": "Qu’est-ce qui se passe ?!"},
	{"speaker": "Étudiante", "text": "Tout est… noir…"},
	{"speaker": "Guide", "text": "Vous avez brisé l’équilibre."},
	{"speaker": "Étudiante", "text": "Pourquoi je suis la seule éclairée ?!"},
	{"speaker": "Guide", "text": "Parce que vous êtes liée aux œuvres."},
	{"speaker": "Étudiante", "text": "Qu’est-ce que je dois faire ?!"},
	{"speaker": "Guide", "text": "Trois tableaux ont été brisés."},
	{"speaker": "Guide", "text": "Vous devez les restaurer."},
	{"speaker": "Étudiante", "text": "Restaurer… comment ?"},
	{"speaker": "Guide", "text": "Comprenez-les. Chaque tableau est une énigme."},
	{"speaker": "Étudiante", "text": "…D’accord. Je vais essayer."}
]

# Dialogue de fin après 3 puzzles
var dialogue_final = [
	{"speaker": "Étudiante", "text": "C’est… terminé ?"},
	{"speaker": "Guide", "text": "Oui. Les trois œuvres sont restaurées."},
	{"speaker": "Étudiante", "text": "J’ai vu leurs émotions…"},
	{"speaker": "Guide", "text": "Elles vivent à travers ceux qui les comprennent."}
]

const PIECE_SCENE = preload("res://scenes/Piece.tscn")
const IMAGE = preload("res://assets/puzzle1.jpg")

const COLS = 3
const ROWS = 3

var pieces_placed := 0
var total_pieces := COLS * ROWS

func _ready():
	_generate_puzzle()
	# Lancer le dialogue du début
	dialogue.start_dialogue(full_dialogue)

func _generate_puzzle():
	var piece_w = IMAGE.get_width() / COLS
	var piece_h = IMAGE.get_height() / ROWS

	var viewport_size = Vector2(1152, 648)
	var grid_origin = Vector2(
		(viewport_size.x - IMAGE.get_width()) / 2.0,
		(viewport_size.y - IMAGE.get_height()) / 2.0
	)

	for row in range(ROWS):
		for col in range(COLS):
			var piece = PIECE_SCENE.instantiate()
			add_child(piece)

			var sprite = piece.get_node_or_null("Sprite2D")
			var collision = piece.get_node_or_null("CollisionShape2D")
			if sprite == null or collision == null:
				push_error("Nœud introuvable dans Piece.tscn")
				return

			var atlas = AtlasTexture.new()
			atlas.atlas = IMAGE
			atlas.region = Rect2(col * piece_w, row * piece_h, piece_w, piece_h)
			sprite.texture = atlas

			var shape = RectangleShape2D.new()
			shape.size = Vector2(piece_w, piece_h)
			collision.shape = shape

			var correct_pos = grid_origin + Vector2(
				col * piece_w + piece_w / 2.0,
				row * piece_h + piece_h / 2.0
			)
			piece.correct_position = correct_pos

			# Position aléatoire
			piece.global_position = Vector2(
				randf_range(piece_w, viewport_size.x - piece_w),
				randf_range(piece_h, viewport_size.y - piece_h)
			)

func check_win():
	pieces_placed += 1
	if pieces_placed >= total_pieces:
		# Lancer le dialogue de fin avant de passer à WinScreen
		dialogue.start_dialogue(dialogue_final, funcref(self, "_go_to_win_screen"))

# Fonction appelée après la fin du dialogue final
func _go_to_win_screen():
	get_tree().change_scene_to_file("res://scenes/WinScreen.tscn")
