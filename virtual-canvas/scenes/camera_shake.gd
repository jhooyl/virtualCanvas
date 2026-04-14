extends Camera2D

var shake_intensity = 0.0

func _process(delta):
	if shake_intensity > 0:
		# On déplace la caméra aléatoirement
		offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		
		# On utilise 0.01 pour que ça tremble pendant les 3 secondes sans s'arrêter
		shake_intensity = lerp(shake_intensity, 0.0, 0.01) 
	else:
		# On remet la caméra à sa place normale (0,0) quand c'est fini
		offset = Vector2.ZERO

func apply_shake(amount):
	shake_intensity = amount
