extends CanvasLayer

# Signal reçu et émis lorsqu'on clique sur quitter dans le menu option du menu des casse-têtes.
func _on_exit_but_pressed():
	visible = false # On ferme le menu d'option du menu des casse-têtes.

# Signal reçu lorsque tous les casse-têtes on été complété.
func _on_menu_puzzle_ui_all_puzzle_win():
	$Big_red_button/Electrical_but.disabled = false # On active le gros bouton rouge qui termine le jeu

# Lorsqu'on appuie sur le gros bouton rouge, le jeu prend fin.
func _on_red_but_pressed():
	Globals.end_game = true
