extends CanvasLayer

signal logical_win

@onready var andGate = $PanelWindow/AndGate
@onready var notGate = $PanelWindow/NotGate
@onready var norGate = $PanelWindow/NorGate
@onready var xnorGate = $PanelWindow/XNorGate
@onready var orGate = $PanelWindow/OrGate
@onready var xorGate = $PanelWindow/XOrGate

@onready var andShadow = $PanelWindow/EmptyGateAnd
@onready var notShadow = $PanelWindow/EmptyGateNot
@onready var notShadow2 = $PanelWindow/EmptyGateNot2
@onready var norShadow= $PanelWindow/EmptyGateNor
@onready var xnorShadow= $PanelWindow/EmptyGateXNor
@onready var orShadow = $PanelWindow/EmptyGateOr
@onready var xorShadow = $PanelWindow/EmptyGateXOr

@onready var buttons = [$PanelWindow/buttonX,
		$PanelWindow/buttonY,
		$PanelWindow/buttonZ] 

var is_button_pressed = {
	#tous les boutons sont à off
	"buttonX": false, 
	"buttonY": false,
	"buttonZ": false
}

func _ready():
	Globals.day_end.connect(on_day_end)

func on_day_end():
	visible = false

func _toggle(button):
	if button != null:
		if button.texture_normal != null and button.texture_normal.get_path() == preload("res://graphics/objects/logic/off.png").get_path():
			button.texture_normal = preload("res://graphics/objects/logic/on.png")
			is_button_pressed[button.name] = true
		else:
			button.texture_normal = preload("res://graphics/objects/logic/off.png")
			is_button_pressed[button.name] = false
		

func _on_button_pressed(button_index):
	var button = buttons[button_index]
	#print(button.name, "pressed")
	_toggle(button)
	light_up_end_light()
	

func check_gates_placement() -> bool:

	if andGate.object_id == andShadow.object_id && notGate.object_id == notShadow.object_id && notGate.object_id == notShadow2.object_id && norGate.object_id == norShadow.object_id && xnorGate.object_id == xnorShadow.object_id && orGate.object_id == orShadow.object_id && xorGate.object_id == xorShadow.object_id :
		logical_win.emit()
		return true
	else:
		return false

func light_up_end_light():
	if check_gates_placement() and is_button_pressed["buttonX"] and is_button_pressed["buttonY"] and is_button_pressed["buttonZ"]: 
		$PanelWindow/closedLight.texture = preload("res://graphics/objects/logic/openLight.png")
	else:
		$PanelWindow/closedLight.texture = preload("res://graphics/objects/logic/closedLight.png")


func _on_logic_box_object_logic_puzzle_clicked():
	visible = true

func _on_close_button_pressed():
	visible = false

func _on_button_z_pressed():
	_on_button_pressed(2)

func _on_button_y_pressed():
	_on_button_pressed(1)

func _on_button_x_pressed():
	_on_button_pressed(0)

