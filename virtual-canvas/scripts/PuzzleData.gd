extends Node

var puzzles = [
	"res://assets/puzzle1.jpg",
	"res://assets/puzzle2.jpg",
	"res://assets/puzzle3.jpg"
]

var current_index := 0

func get_current_image():
	return puzzles[current_index]

func next_puzzle():
	current_index += 1

func is_finished():
	return current_index >= puzzles.size()
