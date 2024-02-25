extends CanvasLayer

func _on_optical_box_object_optical_box_clicked():
	visible = true
	

#On cache l'interface lorsque le bouton quitter est appuyé
func _on_texture_button_pressed():
	visible = false
	
	


func _on_zone_gagnante_body_entered(_body):
	print("entered")
