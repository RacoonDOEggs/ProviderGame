extends Node2D

var optical_puzzle_win_check = false # Variable indiquant que le joueur a complété le casse-tête optique.
var electrical_puzzle_win_check = false # Variable indiquant que le joueur a complété le casse-tête électrique.
var logical_puzzle_win_check = false # Variable indiquant que le joueur a complété le casse-tête logique.
var game_won = false

# On reçoit le signal de la scène du casse-tête optique. (Le joueur l'a complété)
func _on_optical_puzzle_ui_optical_win():
	optical_puzzle_win_check = true
# On reçoit le signal de la scène du casse-tête électrique. (Le joueur l'a complété)
func _on_electrical_box_ui_electrical_win():
	electrical_puzzle_win_check = true



func _process(_delta):
	
	# On vérifie si le joueur a complété tous les casse-têtes
	if optical_puzzle_win_check and electrical_puzzle_win_check and logical_puzzle_win_check:
		game_won = true # Le joueur a gagné le jeu.
