extends CanvasLayer

signal optical_win # Signal indiquant que le casse-tête optique est complété.

func _ready():
	Globals.day_end.connect(on_day_end)

func on_day_end():
	visible = false

# Le signal reçu que le joueur a complété le casse-tête optique.
func _on_laser_win():
	$Win_message.visible = true # On affiche le message disant que le joueur a gagné le casse-tête.
	$PanelWindow/MGForPuzzle/Laser.queue_free() # On supprime le laser pour que le joueur ne puisse plus l'allumer.
	optical_win.emit() # On envoie un signal à la scène principale pour indiquer que le joueur a complété le casse-tête.

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
