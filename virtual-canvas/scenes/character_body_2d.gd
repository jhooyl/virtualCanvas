extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	# 1. Get the direction from your keyboard (Left, Right, Up, Down)
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# 2. If you are pressing keys, move. If not, stop.
	if direction:
		velocity = direction * SPEED
	else:
		velocity = direction * 0

	# 3. This actually makes the character move and hit walls
	move_and_slide()
