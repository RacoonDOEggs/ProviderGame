extends Node2D

signal player_pos_signal(player_pos)

func _process(_delta):
	
	# On enregistre la position du joueur pour que tous les scènes y aillent accès.
	var player_pos = $RedHoodPlaceholder.position
	Globals.player_pos = player_pos
	
	if Globals.game_won:
		print("game won!")
