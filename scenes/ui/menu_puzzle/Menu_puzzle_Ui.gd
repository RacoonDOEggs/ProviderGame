extends CanvasLayer

signal open_electrical_puzzle # Signal indiquant que le bouton du menu du casse-tête électrique est pesé.
signal open_logical_puzzle # Signal indiquant que le bouton du menu du casse-tête électrique est pesé.
signal open_optical_puzzle # Signal indiquant que le bouton du menu du casse-tête électrique est pesé.

var can_open_electrical_puzzle = false # Variable indiquant qu'on peut accéder au casse-tête électrique. (Condition: Les résistances(objet dans la carte) ont été rammassé).
var can_open_logical_puzzle = false # Variable indiquant qu'on peut accéder au casse-tête logique. (Condition: Le casse-tête électrique est complété).
var can_open_optical_puzzle = false # Variable indiquant qu'on peut accéder au casse-tête optique. (Condition: Les 2 casse-têtes précédents sont complétés).
var electrical_puzzle_win_check = false # Variable indiquant que le joueur a complété le casse-tête électrique.
var logical_puzzle_win_check = false # Variable indiquant que le joueur a complété le casse-tête logique.
var optical_puzzle_win_check = false # Variable indiquant que le joueur a complété le casse-tête optique.


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
	electrical_puzzle_win_check = true
	$Logical_button/Logical_but.disabled = false # On active le bouton logique

# Signal reçu lorsqu'on a complété le casse-tête logique.
func _on_logic_circuit_ui_logical_win():
	logical_puzzle_win_check = true
	if !$Optical_button/Optical_but.disabled and !$Logical_button/Logical_but.disabled: # Si le casse-tête électrique et logique ont été complété, on a active le bouton optique..
		$Optical_button/Optical_but.disabled = false # On active le bouton optique.

# Signal reçu lorsqu'on a complété le casse-tête optique.
func _on_optical_puzzle_ui_optical_win():
	optical_puzzle_win_check = true
	Globals.game_won = true # Tous les casse-têtes sont complétés, le joueur a gagné la partie.

# Lorsqu'on ferme le menu des casse-têtes, le joueur peut bouger.
func _on_x_button_pressed():
	visible = false
	Globals.player_speed = 500
