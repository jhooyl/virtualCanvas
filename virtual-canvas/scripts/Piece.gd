extends Area2D

var correct_position: Vector2
var is_placed := false
var dragging := false
var drag_offset := Vector2.ZERO

func _ready():
	input_pickable = true
	connect("input_event", _on_input_event)

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset

func _try_snap():
	if is_placed:       # ← bloque si déjà placée
		return
	var dist = global_position.distance_to(correct_position)
	if dist < 70.0:     # ← monte à 70
		global_position = correct_position
		is_placed = true
		get_parent().check_win()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not is_placed:   # ← bloque le drag si déjà placée
			dragging = true
			drag_offset = global_position - get_global_mouse_position()
			z_index = 10
		elif not event.pressed and dragging:
			dragging = false
			z_index = 0
			_try_snap()
