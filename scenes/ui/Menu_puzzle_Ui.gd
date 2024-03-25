extends CanvasLayer

signal menu_puzzle_exited # Signal émit lorsqu'on ferme le menu des casse-têtes.
signal open_electrical_puzzle # Signal émit lorsque le bouton du menu du casse-tête électrique est pesé.
signal open_logical_puzzle
signal open_optical_puzzle
var can_open_electrical_puzzle = false # Variable indiquant qu'on peut accéder au casse-tête électrique. (Condition: Les résistances(objet dans la carte) ont été rammassé).
var can_open_logical_puzzle = false # Variable indiquant qu'on peut accéder au casse-tête logique. (Condition: Le casse-tête électrique est complété).
var can_open_optical_puzzle = false # Variable indiquant qu'on peut accéder au casse-tête optique. (Condition: Les 2 casse-têtes précédents sont complétés).
var electrical_puzzle_win_check = false # Variable indiquant que le joueur a complété le casse-tête électrique.
var logical_puzzle_win_check = false # Variable indiquant que le joueur a complété le casse-tête logique.
var optical_puzzle_win_check = false # Variable indiquant que le joueur a complété le casse-tête optique.

# Signal reçu lorsque le bouton et émis lorsque le bouton option est pesé.
func _on_texture_button_pressed():
	$".".visible = false
	menu_puzzle_exited.emit()



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

# Signal reçu lorsqu'on a complété le casse-tête logique.
func _on_logic_circuit_ui_logical_win():
	logical_puzzle_win_check = true

# Signal reçu lorsqu'on a complété le casse-tête optique.
func _on_optical_puzzle_ui_optical_win():
	optical_puzzle_win_check = true
