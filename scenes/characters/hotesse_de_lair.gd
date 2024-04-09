extends CharacterBody2D

signal flight_attendant_clicked # Signal indiquant que l'hotesse de lair est pesée.

var mouse_inside:bool = false # Variable indiquant que la souris survole lhotesse de lair

#Mise en évidence de la porte lorsqu'elle est survolée.
#func _on_mouse_entered():
	#$WhitePolygon.visible = true
	#mouse_inside = true
#
##Retrait de la mise en évidence lorsque la souris est enlevée.
#func _on_mouse_exited():
	#$WhitePolygon.visible = false
	#mouse_inside = false

#On émet un signal pour afficher le message lorsque l'hotesse de lair est cliquée
func _input(event):
	if event.is_action_pressed("clicked"):
		flight_attendant_clicked.emit() # On émet un signal vers popupflihgtattendant

# Message reçu lorsque la porte est cliquée. On affiche le message
func _on_plane_door_clicked():
	$PopUpFlightAttendant.visible = true 

