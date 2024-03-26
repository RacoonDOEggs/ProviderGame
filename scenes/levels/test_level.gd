extends Node2D

var game_won = false # Variable indiquant que le joueur a complété le jeu.

# Signal reçcu lorsque tous les casse-têtes on été complété.
func _on_plane_door_all_puzzle_win_2():
	game_won = true
	print("Yay you've won!")
