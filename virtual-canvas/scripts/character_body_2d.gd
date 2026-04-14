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
		if $StepTimer.is_stopped():
			$StepSound.play()
			$StepTimer.start() 

	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()

	move_and_slide()

# --- AJOUT : DÉTECTION DU TABLEAU ---
# --- AJOUT : DÉTECTION DU TABLEAU ---
func _on_area_2d_body_entered(body):
	if body == self:
		# 1. Glitch & Shake (3 seconds)
		var cam = get_node_or_null("Camera2D")
		if cam:
			cam.apply_shake(50.0)
		
		await get_tree().create_timer(3.0).timeout
		
		# 2. Black Screen & Narrative Text
		var noir = get_node_or_null("CanvasLayer/EcranNoir")
		var texte = get_node_or_null("CanvasLayer/TexteTransition")
		
		if noir:
			noir.visible = true
			
		if texte:
			texte.visible = true
			
			# Phrase 1 : Le mystère
			texte.text = "The canvas is bleeding..."
			await get_tree().create_timer(2.0).timeout
			
			# Phrase 2 : Le basculement
			texte.text = "Your memories are fading away."
			await get_tree().create_timer(2.0).timeout
			
			# Phrase 3 : L'annonce du nouveau lieu
			texte.text = "Welcome to the Broken Gallery."
			await get_tree().create_timer(2.5).timeout 
		
		# 3. Scene Transition
		print("Entering the Broken Gallery...")
		get_tree().change_scene_to_file("res://scenes/broken_gallery.tscn")
