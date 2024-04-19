#AUTEUR : Marc-Olivier Beaulieu et Xavier Bilodeau
#PROJET : Provider
#NOM DU FICHIER : globals.gd
#DESCRIPTION : Variables qui sont en mémoire dans toutes les scènes.
extends Node

#Signaux pour indiquer le début et la fin de la journée dans le jeu
signal day_end
signal day_start

#Signaux pour ajouter des items dans l'inventaire du joueur
signal berry_picked(amount:int)
signal herbs_picked(amount:int)
signal wood_picked(amount:int)
signal resistor_picked(amount:int)

# Signal indiquant que la partie a commencé.
signal start_game()

#Signal pour remettre les items ramassés à l'hôtesse de l'air
signal cashout

#Signal pour retirer un item de l'inventaire
signal remove_item(item_id:int, status:Array)

#Signal renvoyé pour savoir si l'item a été placé avec succès
signal item_placed(item_id:int, status:bool)

#Signal pour indiquer que l'inventaire est plein
signal inventory_full()

#Signal pour communiquer les dimensions de la carte
signal set_map_dimensions(dimensions:Rect2i)

#Indique si le quota de la journée est atteint
var quota_complete:bool = false

#Indique si le vieux crash a été trouvé
var resistors_acquired:bool = false:
	get:
		return resistors_acquired
	set(value):
		resistors_acquired = value

#Indique l'orientation du joueur
var player_direction: String = "":
	get:
		return player_direction
	set(value):
		player_direction = value

#Indique la position du joueur
var player_pos: Vector2 = Vector2.ZERO:
	get:
		return player_pos
	set(value):
		player_pos = value

#Indique la vitesse max du joueur
var player_speed: int = 500:
	get:
		return player_speed
	set(value):
		player_speed = value

#Indique si la partie est gagnée
var game_won: bool = false:
	get:
		return game_won
	set(value):
		game_won = value

#Indique si la partie est terminée
signal game_end
var end_game: bool = false:
	get:
		return end_game
	set(value):
		end_game = value
