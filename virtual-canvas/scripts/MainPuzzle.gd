extends Node2D

const PIECE_SCENE = preload("res://scenes/Piece.tscn")

const COLS = 3
const ROWS = 3
#const PIECE_SIZE = 100  # taille de chaque pièce en pixels

var pieces_placed := 0
var total_pieces := COLS * ROWS

func _ready():
	_generate_puzzle()

func _generate_puzzle():
	var IMAGE = load(PuzzleData.get_current_image())
	
	var piece_w = IMAGE.get_width()  / COLS   # 564/3 = 188
	var piece_h = IMAGE.get_height() / ROWS   # 450/3 = 150

	var viewport_size = Vector2(1152, 648)    # ← taille fixe de ta fenêtre

	var grid_origin = Vector2(
		(viewport_size.x - IMAGE.get_width())  / 2.0,   # (1152-564)/2 = 294
		(viewport_size.y - IMAGE.get_height()) / 2.0    # (648-450)/2  = 99
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

			# Position aléatoire en dehors de la zone de la grille
			piece.global_position = Vector2(
				randf_range(piece_w, viewport_size.x - piece_w),
				randf_range(piece_h, viewport_size.y - piece_h)
			)

func check_win():
	pieces_placed += 1
	print("Pièces placées : ", pieces_placed, " / ", total_pieces)
	if pieces_placed >= total_pieces:
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/WinScreen.tscn")
