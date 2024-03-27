extends CanvasLayer

signal menu_puzzle_exited # Signal indiquant qu'on ferme le menu des casse-têtes.
signal open_electrical_puzzle # Signal indiquant que le bouton du menu du casse-tête électrique est pesé.
signal open_logical_puzzle # Signal indiquant que le bouton du menu du casse-tête électrique est pesé.
signal open_optical_puzzle # Signal indiquant que le bouton du menu du casse-tête électrique est pesé.
signal all_puzzle_win # Signal indiquant que tous les casse-têtes on été complété.
signal end_game_2 # Signal indiquant la fin du jeu (le gros bouton rouge a été appuyé).


var can_open_electrical_puzzle = false # Variable indiquant qu'on peut accéder au casse-tête électrique. (Condition: Les résistances(objet dans la carte) ont été rammassé).
var can_open_logical_puzzle = false # Variable indiquant qu'on peut accéder au casse-tête logique. (Condition: Le casse-tête électrique est complété).
var can_open_optical_puzzle = false # Variable indiquant qu'on peut accéder au casse-tête optique. (Condition: Les 2 casse-têtes précédents sont complétés).
var electrical_puzzle_win_check = false # Variable indiquant que le joueur a complété le casse-tête électrique.
var logical_puzzle_win_check = false # Variable indiquant que le joueur a complété le casse-tête logique.
var optical_puzzle_win_check = false # Variable indiquant que le joueur a complété le casse-tête optique.

func _process(_delta):
	if electrical_puzzle_win_check and logical_puzzle_win_check and optical_puzzle_win_check:
		all_puzzle_win.emit() # On émet un signal indiquant que tous les casse-têtes on été complété.

# Signal reçu lorsque le bouton option est pesé.
func _on_texture_button_pressed():
	$Option_panel_for_menu_puzzle.visible = true

# Signal reçu et émis lorsque le bouton du menu du casse-tête électrique est pesé.
func _on_electrical_but_pressed():
	open_electrical_puzzle.emit()

# Signal reçu et émis lorsque le bouton du menu du casse-tête logique est pesé.
func _on_logical_but_pressed():
	open_logical_puzzle.emit()

# Signal reçu et émis lorsque le bouton du menu du casse-tête optique est pesé.
func _on_optical_but_pressed():
	open_optical_puzzle.emit()

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

# Signal reçu et émis lorsque le gros bouton rouge du menu option est appuyé.
func _on_option_panel_for_menu_puzzle_end_game():
	end_game_2.emit()

# Signal reçu et émis lorsqu'on appuie sur le bouton X du menu des casse-têtes.
func _on_x_button_pressed():
	visible = false
	menu_puzzle_exited.emit()
