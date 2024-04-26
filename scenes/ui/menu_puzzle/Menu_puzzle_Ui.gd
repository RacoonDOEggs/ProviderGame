extends CanvasLayer

signal open_electrical_puzzle # Signal indiquant que le bouton du menu du casse-tête électrique est pesé.
signal open_logical_puzzle # Signal indiquant que le bouton du menu du casse-tête électrique est pesé.
signal open_optical_puzzle # Signal indiquant que le bouton du menu du casse-tête électrique est pesé.

func _ready():
	Globals.day_end.connect(_on_x_button_pressed)

# Signal reçu lorsque le bouton option est pesé.
func _on_texture_button_pressed():
	$Option_panel_for_menu_puzzle.visible = true

# On affiche le casse-tête électrique lorsque le bouton est appuyé.
func _on_electrical_but_pressed():
	$ElectricalBoxUI._on_electrical_box_object_electrical_box_clicked()

# On affiche le casse-tête logique lorsque le bouton est appuyé.
func _on_logical_but_pressed():
	$logic_circuit_ui.visible = true

# On affiche le casse-tête optique lorsque le bouton est appuyé.
func _on_optical_but_pressed():
	$Optical_puzzle_ui.visible = true

# Signal reçu lorsqu'on a complété le casse-tête électrique.
func _on_electrical_box_ui_electrical_win():
	$Logical_button/Logical_but.disabled = false # On active le bouton logique

# Signal reçu lorsqu'on a complété le casse-tête logique.
func _on_logic_circuit_ui_logical_win():
	if !$Electrical_button/Electrical_but.disabled and !$Logical_button/Logical_but.disabled: # Si le casse-tête électrique et logique ont été complété, on a active le bouton optique..
		$Optical_button/Optical_but.disabled = false # On active le bouton optique.

# Lorsqu'on ferme le menu des casse-têtes, le joueur peut bouger.
func _on_x_button_pressed():
	visible = false
	Globals.player_speed = 500

# Si le joueur pèse sur le gros bouton rouge, on ferme le menu des casse-têtes.
func _on_option_panel_for_menu_puzzle_red_but_pressed():
	$".".visible = false
