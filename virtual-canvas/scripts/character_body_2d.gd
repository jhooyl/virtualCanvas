extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction:
		velocity = direction * SPEED
		
		# Play the correct animation
		if direction.x > 0: $AnimatedSprite2D.play("walk_right")
		elif direction.x < 0: $AnimatedSprite2D.play("walk_left")
		elif direction.y > 0: $AnimatedSprite2D.play("walk_down")
		elif direction.y < 0: $AnimatedSprite2D.play("walk_up")

		# --- RHYTHM LOGIC ---
		# Only play the sound if the timer is stopped
		if $StepTimer.is_stopped():
			$StepSound.play()
			$StepTimer.start() # This "waits" 0.4 seconds before the next tap
		
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()
		# We don't need to stop the sound here anymore, it will just finish its tap
	
	move_and_slide()
