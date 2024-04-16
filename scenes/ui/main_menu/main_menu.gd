extends CanvasLayer


func _on_play_button_pressed():
	Globals.start_game.emit()
	$".".queue_free()

func _on_credits_button_pressed():
	pass # Replace with function body.


# On ferme l'application.
func _on_exit_button_pressed():
	get_tree().quit()
