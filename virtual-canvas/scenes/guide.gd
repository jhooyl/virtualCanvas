extends CharacterBody2D

const SPEED = 100.0
var doit_marcher = false

func _physics_process(delta: float) -> void:
	# On gère la marche seulement si doit_marcher est vrai
	if doit_marcher:
		velocity.x = SPEED
	else:
		# Le guide reste immobile pour parler tranquillement
		velocity = Vector2.ZERO

	move_and_slide()

# Fonction déclenchée quand Amelia entre dans la zone
func _on_zone_detection_body_entered(body: Node2D) -> void:
	if body.name == "Amelia":
		print("Amelia détectée !")
		
		# On affiche la bulle (on teste les deux noms possibles)
		if has_node("BulleDialogue"):
			$BulleDialogue.show()
		elif has_node("PanelContainer"):
			$PanelContainer.show()
		
		# Si tu veux qu'il commence à marcher en même temps, 
		# change false en true ci-dessous :
		doit_marcher = false 

# OPTIONNEL : Pour cacher la bulle quand Amelia s'en va
func _on_zone_detection_body_exited(body: Node2D) -> void:
	if body.name == "Amelia":
		if has_node("BulleDialogue"):
			$BulleDialogue.hide()
		elif has_node("PanelContainer"):
			$PanelContainer.hide()
