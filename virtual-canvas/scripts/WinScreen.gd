extends CanvasLayer

func _ready():
	await get_tree().create_timer(2.0).timeout

	PuzzleData.next_puzzle()
	if PuzzleData.is_finished():
		get_tree().change_scene_to_file("res://scenes/broken_gallery.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/MainPuzzle.tscn")
