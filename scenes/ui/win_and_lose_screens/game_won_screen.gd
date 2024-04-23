extends CanvasLayer


# On affiche les crédits lorsqu'on appuie sur le bouton Retourner au menu.
func _on_return_button_pressed():
	Globals.reload_project.emit()

# On ferme l'application.
func _on_exit_button_pressed():
	get_tree().quit()
