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

var buttons = [] 
var is_button_pressed = {
	#tous les boutons sont à off
	"buttonX": false, 
	"buttonY": false,
	"buttonZ": false
}
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		for button_index in range(buttons.size()):
			var button = buttons[button_index]
			if button.get_global_rect().has_point(event.position):
				_on_button_pressed(button_index)
				light_up_end_light()

func _toggle(button):
	if button != null:
		if button.texture_normal != null and button.texture_normal.get_path() == preload("res://graphics/objects/logic/off.png").get_path():
			button.texture_normal = preload("res://graphics/objects/logic/on.png")
			is_button_pressed[button.name] = true
		else:
			button.texture_normal = preload("res://graphics/objects/logic/off.png")
			is_button_pressed[button.name] = false
			

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
	var andGatePos = andGate.global_position
	var notGatePos = notGate.global_position
	var norGatePos = norGate.global_position
	var xnorGatePos = xnorGate.global_position
	var orGatePos = orGate.global_position
	var xorGatePos = xorGate.global_position

	var andShadowRect = andShadow.get_global_rect()
	var notShadowRect = notShadow.get_global_rect()
	var notShadow2Rect = notShadow2.get_global_rect()
	var norShadowRect = norShadow.get_global_rect()
	var xnorShadowRect = xnorShadow.get_global_rect()
	var orShadowRect = orShadow.get_global_rect()
	var xorShadowRect = xorShadow.get_global_rect()


	if andShadowRect.has_point(andGatePos) && notShadowRect.has_point(notGatePos) && notShadow2Rect.has_point(notGatePos) && norShadowRect.has_point(norGatePos) && xnorShadowRect.has_point(xnorGatePos) && orShadowRect.has_point(orGatePos) && xorShadowRect.has_point(xorGatePos):
		logical_win.emit()
		return true
	else:
		return false
	#if andGate.object_id == andShadow && notGate.object_id == notShadow && notGate.object_id == notShadow2 && norGate.object_id == norShadow && xnorGate.object_id == xnorShadow && orGate.object_id == orShadow && xorGate.object_id == xorShadow :
		#logical_win.emit()
		#return true
	#else:
		#return false

func light_up_end_light():
		var all_buttons_pressed = is_button_pressed["buttonX"] && is_button_pressed["buttonY"] && is_button_pressed["buttonZ"]
		if check_gates_placement() && all_buttons_pressed: 
			$PanelWindow/closedLight.texture = load("res://graphics/objects/logic/openLight.png")
			
		else:
			$PanelWindow/closedLight.texture = load("res://graphics/objects/logic/closedLight.png")
		

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
