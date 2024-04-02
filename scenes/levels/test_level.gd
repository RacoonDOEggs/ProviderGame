extends Node2D

signal player_pos_signal(player_pos)

func _process(_delta):
	
	# On enregistre la position du joueur pour que tous les scènes y aillent accès.
	var player_pos = $RedHoodPlaceholder.position
	Globals.player_pos = player_pos



# Signal reçu lorsque le jeu est terminé(le gros bouton rouge a été cliqué).
func _on_plane_door_end_game_3():
	print("Bravo tu as gagné la partie")
