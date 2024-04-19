#AUTEUR : Marc-Olivier Beaulieu et Xavier Bilodeau
#PROJET : Provider
#NOM DU FICHIER : red_hood_placeholder.gd
#DESCRIPTION : Logique derrière les mouvement du joueur
extends CharacterBody2D

func _ready():
	Globals.set_map_dimensions.connect(on_set_map_dimensions)
	Globals.day_end.connect(on_day_end)

# Fonction qui régis le mouvement et la vitesse du joueur.
func _process(_delta):
	var direction:Vector2 = Input.get_vector("left", "right", "up", "down")
	
	velocity = direction * Globals.player_speed
	move_and_slide()

#Mise à jour des limites du monde pour la caméra
func on_set_map_dimensions(dimensions:Rect2i):
	$Camera2D.limit_left = dimensions.position.x * 96
	$Camera2D.limit_top = dimensions.position.y * 96
	$Camera2D.limit_right = dimensions.end.x * 96
	$Camera2D.limit_bottom = dimensions.end.y * 96

func on_day_end():
	await get_tree().create_timer(1).timeout
	position = Vector2i(15,654)