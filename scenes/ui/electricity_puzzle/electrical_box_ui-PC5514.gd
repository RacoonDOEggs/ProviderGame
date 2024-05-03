#AUTEUR : Marc-Olivier Beaulieu
#PROJET : Provider
#NOM DU FICHIER : electrical_box_ui.gd
#DESCRIPTION : Logique derrière le casse-tête de résistances
extends CanvasLayer

signal electrical_win # Signal indiquant que le casse-tête électrique est complété.

@export var input_voltage:int = 50
@export var R1_solution:int = 44000
@export var R2_solution:int = 400000
@export var R3_solution:int = 45000
@export var R4_solution:int = 54000
@export var R5_solution:int = 99000

@onready var R1:DragAndDrop = $PanelWindow/HBoxContainer/VBoxContainer1/MarginContainer/ResistorReceptacle4
@onready var R2:DragAndDrop = $PanelWindow/HBoxContainer/VBoxContainer2/ResistorReceptacle5
@onready var R3:DragAndDrop = $PanelWindow/HBoxContainer/VBoxContainer2/ResistorReceptacle6
@onready var R4:DragAndDrop = $PanelWindow/HBoxContainer/VBoxContainer3/MarginContainer/ResistorReceptacle2
@onready var R5:DragAndDrop = $PanelWindow/HBoxContainer/VBoxContainer2/ResistorReceptacle3

@onready var ResistorReceptacle2:DragAndDrop = $PanelWindow/HBoxContainer2/MarginContainer/ResistorReceptacle2
@onready var ResistorReceptacle4:DragAndDrop = $PanelWindow/HBoxContainer2/MarginContainer2/ResistorReceptacle4
@onready var ResistorReceptacle5:DragAndDrop = $PanelWindow/HBoxContainer2/MarginContainer3/ResistorReceptacle5

@onready var amp_top_label:Label = $PanelWindow/HBoxContainer/VBoxContainer/MarginContainer/AmpTop
@onready var amp_mid_label:Label = $PanelWindow/HBoxContainer/VBoxContainer/MarginContainer2/AmpMid
@onready var amp_bot_label:Label = $PanelWindow/HBoxContainer/VBoxContainer/MarginContainer3/AmpBot
@onready var in_voltage_label:Label = $PanelWindow/HBoxContainer/MarginContainer/InVoltage
@onready var mid_voltge_label:Label = $PanelWindow/HBoxContainer/VBoxContainer1/MarginContainer2/MidVoltage

func _ready():
	Globals.day_end.connect(on_day_end)

func on_day_end():
	visible = false

#On affiche l'interface lorsque le signal est reçu.
func _on_electrical_box_object_electrical_box_clicked():
	visible = true
	var item_is_removed = [false]
	if Globals.resistors_acquired == true:
		if ResistorReceptacle2.visible == false:
			Globals.remove_item.emit(3, item_is_removed)
			if item_is_removed[0]:
				ResistorReceptacle2.visible = true
		item_is_removed[0] = false
		if ResistorReceptacle4.visible == false:
			Globals.remove_item.emit(3, item_is_removed)
			if item_is_removed[0]:
				ResistorReceptacle4.visible = true
		item_is_removed[0] = false
		if ResistorReceptacle5.visible == false:
			Globals.remove_item.emit(3, item_is_removed)
			if item_is_removed[0]:
				ResistorReceptacle5.visible = true
		item_is_removed[0] = false
		
	update_circuit_measurements()

#On cache l'interface lorsque le X est appuyé.
func _on_texture_button_pressed():
	visible = false

#On cache l'interface lorsque la touche échap est appuyée
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			visible = false

#Calcul les mesures du circuit et les affiche dans les étiquettes.
func update_circuit_measurements():
	in_voltage_label.text = str(input_voltage) + "V"
	if R1.object_id != 0 && R2.object_id != 0 && R3.object_id != 0 && R4.object_id != 0 && R5.object_id != 0:
		var r_eq = pow(((1/R2.object_value) + (1/(R3.object_value + R4.object_value)) + (1/R5.object_value)), -1)
		var mid_voltage = (input_voltage * r_eq) / (R1.object_value + r_eq)
		mid_voltge_label.text = str(mid_voltage) + "V"
		var amp_top = mid_voltage / R2.object_value
		var amp_mid = mid_voltage / (R3.object_value + R4.object_value)
		var amp_bot = mid_voltage / (R5.object_value)
		amp_top_label.text = amp_to_str(amp_top)
		amp_mid_label.text = amp_to_str(amp_mid)
		amp_bot_label.text = amp_to_str(amp_bot)
	else:
		pass

#Vérifie la réponse entrée
func validate_circuit() -> bool:
	if R1.object_value == R1_solution && R2.object_value == R2_solution && R3.object_value == R3_solution && R4.object_value == R4_solution && R5.object_value == R5_solution:
		$PanelWindow/ColorRect.modulate = Color(0.0,1.0,0.0)
		return true
	else:
		$PanelWindow/ColorRect.modulate = Color(1.0,0.0,0.0)
		return false

#Convertis une valeur en Ampères et retourne une String avec les bonnes unités.
func amp_to_str(value:float) -> String:
	if value < 0.001:
		return  str(value / 0.000001) + "μA"
	elif value < 0.01:
		return  str(value / 0.0001) + "mA"
	else:
		return  str(value) + "A"

#Fonction appelée quand le disjoncteur est appuyé.
func _on_validate_button_pressed():
	update_circuit_measurements()
	if !validate_circuit():
		$PanelWindow/HBoxContainer2/TextureButton.button_pressed = false
	else:
		$PanelWindow/HBoxContainer2/TextureButton.disabled = true #
		$Win_message.visible = true # On affiche le message disant que le joueur a gagné le casse-tête.
		electrical_win.emit()
		# Les receptacles de résistance du milieu de la scène ne peuvent plus recevoir de résistance.
		R1.is_dragable = false
		R2.is_dragable = false
		R3.is_dragable = false
		R4.is_dragable = false
		R5.is_dragable = false
