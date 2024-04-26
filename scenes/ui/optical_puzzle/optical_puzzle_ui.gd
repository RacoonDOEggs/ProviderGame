extends CanvasLayer

func _ready():
	Globals.day_end.connect(on_day_end)

func on_day_end():
	visible = false

#On affiche la scène lorsque le signal est reçu.
func _on_optical_box_object_optical_box_clicked():
	visible = true

#On cache l'interface lorsque le bouton quitter est appuyé.
func _on_texture_button_pressed():
	visible = false

#On cache l'interface lorsque la touche échap est appuyée.
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			visible = false

# Le signal reçu que le joueur a complété le casse-tête optique.
func _on_laser_optical_win():
	$Win_message.visible = true # On affiche le message disant que le joueur a gagné le casse-tête.
	$PanelWindow/MGForPuzzle/Laser.queue_free() # On supprime le laser pour que le joueur ne puisse plus l'allumer.
