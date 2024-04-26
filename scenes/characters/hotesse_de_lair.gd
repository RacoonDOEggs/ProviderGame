#AUTEUR : Marc-Olivier Beaulieu
#PROJET : Provider
#NOM DU FICHIER : hotesse_de_lair.gd
#DESCRIPTION : Logique derrière l'intéraction avec l'hôtesse de l'air.
extends CharacterBody2D

#Indique si la souris est sur l'hôtesse.
var mouse_is_inside:bool

#Appelé quand la souris ne survole plus l'hôtesse
func _on_mouse_exited():
	$Sprite2D.modulate = Color(1.0,1.0,1.0,1.0)
	mouse_is_inside = false

#Appelé quand la souris survole l'hôtesse
func _on_mouse_entered():
	$Sprite2D.modulate = Color(1.1,1.1,1.1,1.0)
	mouse_is_inside = true

#Appelé quand le joueur appuis sur une touche ou la souris
func _unhandled_input(event):
	if event.is_action_pressed("clicked") and mouse_is_inside:
		Globals.cashout.emit()
