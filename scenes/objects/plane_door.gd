extends Area2D

signal plane_door_clicked # Signal indiquant que la porte a été cliqué.
var mouse_inside:bool = false # Variable indiquant que la souris survole la porte.

#Mise en évidence de la porte lorsqu'elle est survolée.
func _on_mouse_entered():
	$WhitePolygon.visible = true
	mouse_inside = true

#Retrait de la mise en évidence lorsque la souris est enlevée.
func _on_mouse_exited():
	$WhitePolygon.visible = false
	mouse_inside = false

#On émet un signal pour afficher l'interface lorsque la boîte optique est cliquée
func _input(event):
	if event.is_action_pressed("clicked") and mouse_inside:
		plane_door_clicked.emit()
