extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	# 1. Get the direction from your keyboard
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# 2. Movement Logic
	if direction:
		velocity = direction * SPEED
		
		# --- ANIMATION MAGIC STARTS HERE ---
		# This tells her which way to look based on your keys
		if direction.x > 0:
			$AnimatedSprite2D.play("walk_right")
		elif direction.x < 0:
			$AnimatedSprite2D.play("walk_left")
		elif direction.y > 0:
			$AnimatedSprite2D.play("walk_down")
		elif direction.y < 0:
			$AnimatedSprite2D.play("walk_up")
		# ------------------------------------
		
	else:
		velocity = Vector2.ZERO
		# --- STOP THE LEGS ---
		$AnimatedSprite2D.stop() 
	
	move_and_slide()
