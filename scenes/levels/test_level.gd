#AUTEUR : Marc-Olivier Beaulieu et Xavier Bilodeau
#PROJET : Provider
#NOM DU FICHIER : test_level.gd
#DESCRIPTION : Logique du niveau
extends Node2D

signal player_pos_signal(player_pos)

func _ready():
	Globals.inventory_full.connect(on_inventory_full)
	Globals.start_game.connect(on_start_game)
	
	if $OldPlane.visible == false:
		$OldPlane.queue_free()
	
	Globals.player_speed = 0

func _process(_delta):
	# On enregistre la position du joueur pour que tous les scènes y aillent accès.
	var player_pos = $RedHoodPlaceholder.position
	Globals.player_pos = player_pos
	

# Si l'inventaire est plein, on affiche un message pendant 2 sec.
func on_inventory_full():
	$Player_in_game_UI.visible = true
	await get_tree().create_timer(2.0).timeout
	$Player_in_game_UI.visible = false

#Si on appuie sur le bouton JOUER, la génération se lance.
func on_start_game():
	$MapGenerator._on_start()
