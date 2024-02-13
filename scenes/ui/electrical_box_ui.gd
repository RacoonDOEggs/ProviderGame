extends CanvasLayer

@export var input_voltage:int = 50
@export var R1_solution:int = 44000
@export var R2_solution:int = 400000
@export var R3_solution:int = 45000
@export var R4_solution:int = 54000
@export var R5_solution:int = 99000

@onready var R1:DragAndDrop = $PanelWindow/HBoxContainer/VBoxContainer1/ResistorReceptacle4
@onready var R2:DragAndDrop = $PanelWindow/HBoxContainer/VBoxContainer2/ResistorReceptacle5
@onready var R3:DragAndDrop = $PanelWindow/HBoxContainer/VBoxContainer2/ResistorReceptacle6
@onready var R4:DragAndDrop = $PanelWindow/HBoxContainer/VBoxContainer3/ResistorReceptacle2
@onready var R5:DragAndDrop = $PanelWindow/HBoxContainer/VBoxContainer2/ResistorReceptacle3
@onready var amp_top_label:Label = $PanelWindow/HBoxContainer/VBoxContainer/AmpTop
@onready var amp_mid_label:Label = $PanelWindow/HBoxContainer/VBoxContainer/AmpMid
@onready var amp_bot_label:Label = $PanelWindow/HBoxContainer/VBoxContainer/AmpBot
@onready var in_voltage_label:Label = $PanelWindow/HBoxContainer/InVoltage
@onready var mid_voltge_label:Label = $PanelWindow/HBoxContainer/VBoxContainer1/MidVoltage

#On affiche l'interface lorsque le signal est reçu
func _on_electrical_box_object_electrical_box_clicked():
	visible = true
	update_circuit_measurements()

#On cache l'interface lorsque le bouton quitter est appuyé
func _on_texture_button_pressed():
	visible = false

#On cache l'interface lorsque la touche échap est appuyée
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			visible = false


func update_circuit_measurements():
	in_voltage_label.text = str(input_voltage) + "V"
	if R1.object_value != 0 && R2.object_value != 0 && R3.object_value != 0 && R4.object_value != 0 && R5.object_value != 0:
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

func validate_circuit():
	if R1.object_value == R1_solution && R2.object_value == R2_solution && R3.object_value == R3_solution && R4.object_value == R4_solution && R5.object_value == R5_solution:
		$PanelWindow/ColorRect.modulate = Color(0.0,1.0,0.0)

func amp_to_str(value:float) -> String:
	if value < 0.001:
		return str(value / 0.000001) + "μA"
	elif value < 0.01:
		return str(value / 0.0001) + "mA"
	else:
		return str(value) + "A"


func _on_button_pressed():
	update_circuit_measurements()
	validate_circuit()
