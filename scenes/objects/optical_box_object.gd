extends Area2D

signal optical_box_clicked

var mouse_inside:bool = false

#Mise en évidence de la boîte optique lorsqu'elle est survolée
func _on_mouse_entered():
	$WhiteRectangle.visible = true
	mouse_inside = true

#Retrait de la mise en évidence lorsque la souris est enlevée
func _on_mouse_exited():
	$WhiteRectangle.visible = false
	mouse_inside = false

#On émet un signal pour afficher l'interface lorsque la boîte optique est cliquée
func _input(event):
	if event.is_action_pressed("clicked") and mouse_inside:
		optical_box_clicked.emit()


func _on_electrical_box_object_2_electrical_box_clicked():
	pass # Replace with function body.
