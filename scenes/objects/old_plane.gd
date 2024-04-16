#AUTEUR : Marc-Olivier Beaulieu
#PROJET : Provider
#NOM DU FICHIER : old_plane.gd
#DESCRIPTION : Logique du vieux crash d'avion
extends StaticBody2D

#Indique si la souris est sur l'avion
var mouse_is_inside:bool = false

#Appelé quand la souris sors de l'avion
func _on_mouse_exited():
	$OldPlaneSprite.modulate = Color(1.0,1.0,1.0,1.0)
	mouse_is_inside = false

#Appelé quand la souris entre dans l'avion
func _on_mouse_entered():
	$OldPlaneSprite.modulate = Color(1.1,1.1,1.1,1.0)
	mouse_is_inside = true

#Appelé quand le joueur appuie sur une touche ou la souris
func _unhandled_input(event):
	if event.is_action_pressed("clicked") and mouse_is_inside:
		Globals.resistor_picked.emit(3)
		self.input_pickable = false
