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

#var placed_gates = {}
var buttons = [] 
var is_button_pressed = {
	#all the buttons are off
	"buttonX": false, 
	"buttonY": false,
	"buttonZ": false
}
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		for button_index in range(buttons.size()):
			var button = buttons[button_index]
			if button.get_rect().has_point(event.position):
				_on_button_pressed(button_index)

func _toggle(button):
	if button != null:
		if button.texture_normal == load("res://graphics/objects/logic/off.png"):
			button.texture_normal = load("res://graphics/objects/logic/on.png")
			is_button_pressed[button.name] = true
		else:
			button.texture_normal = load("res://graphics/objects/logic/off.png")

func _ready():
	buttons = [
		$PanelWindow/buttonX,
		$PanelWindow/buttonY,
		$PanelWindow/buttonZ]

func _on_button_pressed(button_index):
	var button = buttons[button_index]
	#print("Button", button.name, "pressed")
	_toggle(button)

func check_gates_placement() -> bool:
	if andGate.object_id == andShadow && notGate.object_id == notShadow && notGate.object_id == notShadow2 && norGate.object_id == norShadow && xnorGate.object_id == xnorShadow && orGate.object_id == orShadow && xorGate.objetc_id == xorShadow :
		logical_win.emit()
		return true
	else:
		return false

func light_up_end_light():

	if !check_gates_placement() && is_button_pressed == false :
			$PanelWindow/closedLight.texture = load("res://graphics/objects/logic/closedLight.png")
			
	else:
		$PanelWindow/closedLight.texture = load("res://graphics/objects/logic/openLight.png")
		

#func _process(_delta):
	#pass
#
#func _on_ButtonX_pressed():
	#print ('ButtonX is clicked')
	##connect doors and strings 
	#
#func _on_ButtonY_pressed():
	#print('ButtonY is clicked')
	##connect rest
	#
#func _on_ButtonZ_pressed():
	#print('ButtonZ is clicked')
	##connect rest
#

func _on_logic_box_object_logic_puzzle_clicked():
	visible = true


func _on_close_button_pressed():
	visible = false
