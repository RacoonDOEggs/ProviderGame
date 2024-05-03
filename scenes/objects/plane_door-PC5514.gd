#AUTEUR :  Xavier Bilodeau
#PROJET : Provider
#NOM DU FICHIER : plane_door.gd
#DESCRIPTION : Porte de l'avion ouvrant le menu des casse-têtes lorsqu'on clique sur celle-ci.
extends Area2D

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
		plane_door_clicked.emit() # On émet un signal vers Menu_puzzle_Ui.

# Message reçu lorsque la porte est cliquée. On affiche le menu des casse-têtes.
func _on_plane_door_clicked():
	$Menu_puzzle_Ui.visible = true 
	Globals.player_speed = 0
