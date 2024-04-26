extends CanvasLayer

signal credit_opened()

# On commence le jeu lorsqu'on appuie sur le bouton JOUER.
func _on_play_button_pressed():
	Globals.start_game.emit()
	$".".queue_free()
	Globals.player_speed = 500

# On affiche les crédits lorsqu'on appuie sur le bouton CRÉDITS.
func _on_credits_button_pressed():
	credit_opened.emit()

# On ferme l'application.
func _on_exit_button_pressed():
	get_tree().quit()
