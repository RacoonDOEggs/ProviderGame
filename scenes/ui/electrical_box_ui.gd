extends CanvasLayer

@onready var resistor1:DragAndDrop = $PanelWindow/HBoxContainer/VBoxContainer/ResistorReceptacle2
@onready var resistor2:DragAndDrop = $PanelWindow/HBoxContainer/VBoxContainer2/ResistorReceptacle3
@onready var resistor3:DragAndDrop = $PanelWindow/HBoxContainer/VBoxContainer3/ResistorReceptacle5
@onready var resistor4:DragAndDrop = $PanelWindow/HBoxContainer/VBoxContainer3/ResistorReceptacle6
@onready var resistor5:DragAndDrop = $PanelWindow/HBoxContainer/VBoxContainer3/ResistorReceptacle7



#On affiche l'interface lorsque le signal est reçu
func _on_electrical_box_object_electrical_box_clicked():
	visible = true

#On cache l'interface lorsque le bouton quitter est appuyé
func _on_texture_button_pressed():
	visible = false

#On cache l'interface lorsque la touche échap est appuyée
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			visible = false
