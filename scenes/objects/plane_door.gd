extends Area2D

signal player_can_move # Signal indiquant que le joueur peut être en mouvement encore.
signal plane_door_clicked # Signal indiquant que la porte de l'avion est pesée.

var mouse_inside:bool = false # Variable indiquant que la souris survole la porte.

#Mise en évidence de la porte lorsqu'elle est survolée.
func _on_mouse_entered():
	$WhitePolygon.visible = true
	mouse_inside = true

#Retrait de la mise en évidence lorsque la souris est enlevée.
func _on_mouse_exited():
	$WhitePolygon.visible = false
	mouse_inside = false

#On émet un signal pour afficher le menu des casse-têtes lorsque la porte est cliquée
func _input(event):
	if event.is_action_pressed("clicked") and mouse_inside:
		plane_door_clicked.emit()


# Message reçu lorsque la porte est cliquée. On affiche le menu des casse-têtes.
func _on_plane_door_clicked():
	$Menu_puzzle_Ui.visible = true 

# Message reçu lorsque le bouton du casse-tête électrique est choisi. On affiche le casse-tête électrique.
func _on_menu_puzzle_ui_open_electrical_puzzle():
	$ElectricalBoxUI.visible = true

# Message reçu lorsque le bouton du casse-tête logique est choisi. On affiche le casse-tête logique.
func _on_menu_puzzle_ui_open_logical_puzzle():
	$logic_circuit_ui.visible = true
	

# Message reçu lorsque le bouton du casse-tête optique est choisi. On affiche le casse-tête optique.
func _on_menu_puzzle_ui_open_optical_puzzle():
	$Optical_puzzle_ui.visible = true


# Signal reçu du menu ,on en renvoie un autre pour avertir le joueur.
func _on_menu_puzzle_ui_menu_puzzle_exited():
	player_can_move.emit()
