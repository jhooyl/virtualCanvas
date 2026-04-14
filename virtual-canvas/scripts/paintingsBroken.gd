extends Area2D

@onready var ui_label = get_node("/root/glitchGame/Label")

var message_shown = false

func _on_body_entered(body):
	if body.name == "Amelia" and not message_shown:
		message_shown = true
		show_message()

func show_message():
	ui_label.text = "Resolve those puzzles to be able to exit this world"
	ui_label.visible = true

	await get_tree().create_timer(3.0).timeout
	ui_label.visible = false
	get_tree().change_scene_to_file("res://scenes/MainPuzzle.tscn")
