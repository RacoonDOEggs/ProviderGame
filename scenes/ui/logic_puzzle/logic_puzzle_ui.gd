#AUTEUR :  Rime Elbaroudi 
#PROJET : Provider
#NOM DU FICHIER : logic_puzzle_ui.gd
#DESCRIPTION : Scène du casse-tête logique 
extends CanvasLayer

signal logical_win

#Variables pour les objets dans le circuit 
@onready var andGate = $PanelWindow/AndGate
@onready var notGate = $PanelWindow/NotGate
@onready var norGate = $PanelWindow/NorGate
@onready var xnorGate = $PanelWindow/XNorGate
@onready var orGate = $PanelWindow/OrGate
@onready var xorGate = $PanelWindow/XOrGate
@onready var nandGate = $PanelWindow/NandGate2

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

#cette varible sert à s'assurer que les 3 boutons sont fermés
var is_button_pressed = {
	#tous les boutons sont à off
	"buttonX": false, 
	"buttonY": false,
	"buttonZ": false
}

func _ready():
	Globals.day_end.connect(on_day_end)

#Lorsque le jour se termine dans le jeu, le cass_tête n'est plus visible
func on_day_end():
	visible = false

#Cette fonction permet de changer la texture des boutons lorsqu'on appuie dessus
func _toggle(button):
	if button != null:
		#Lorsque le bouton n'a pas encore cliqué, sa texture est à « off »
		if button.texture_normal != null and button.texture_normal.get_path() == preload("res://graphics/objects/logic/off.png").get_path():
			button.texture_normal = preload("res://graphics/objects/logic/on.png")
			is_button_pressed[button.name] = true
		else:
			button.texture_normal = preload("res://graphics/objects/logic/off.png")
			is_button_pressed[button.name] = false
		

#Fonction pour indiquer si les butons sont cliqués
func _on_button_pressed(button_index):
	var button = buttons[button_index]
	_toggle(button)
	light_up_end_light()
	

#Cette fonction sert à s'assurer l'emplacement des portes dans le circuit
func check_gates_placement() -> bool:
<<<<<<< HEAD
	#En s'assurant que le object id de la porte est égale à celle de son emplacement (ombre) correspondant, on peut s'assurer de leur emplacement
=======
>>>>>>> 8521f3cf19c90645ea417b3e061f3647d4a53931
	if andGate.object_id == andShadow.object_id && notGate.object_id == notShadow.object_id && notGate.object_id == notShadow2.object_id && norGate.object_id == norShadow.object_id && xnorGate.object_id == xnorShadow.object_id && orGate.object_id == orShadow.object_id && xorGate.object_id == xorShadow.object_id :
		return true
	else:
		return false

#Cette fonction allume une lumière losrque le casse tête est réussi
func light_up_end_light():
	#Lorsque les portes sont toutes au bon endroit et que les 3 boutons sont à « on », la lumière s'allume
	if check_gates_placement() and is_button_pressed["buttonX"] and is_button_pressed["buttonY"] and is_button_pressed["buttonZ"]: 
		$PanelWindow/closedLight.texture = preload("res://graphics/objects/logic/openLight.png")
		$PanelWindow/Win_message.visible = true # On affiche le message disant que le joueur a gagné le casse-tête.
		logical_win.emit() #on envoie un signal pour indiquer que le puzzle est complété
		#lorsque le casse tete est complété, les portes logiques ne peuvent plus bouger
		andGate.is_dragable = false
		notGate.is_dragable = false
		nandGate.is_dragable = false
		xnorGate.is_dragable = false
		xorGate.is_dragable = false
		norGate.is_dragable = false
		orGate.is_dragable = false
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
