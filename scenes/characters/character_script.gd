#AUTEUR : Marc-Olivier Beaulieu et Xavier Bilodeau
#PROJET : Provider
#NOM DU FICHIER : red_hood_placeholder.gd
#DESCRIPTION : Logique derrière les mouvement du joueur
extends CharacterBody2D

var direction:Vector2
var prev_direction:Vector2

@onready var animation_tree = $AnimationTree

#Initialisation, connexion des signaux.
func _ready():
	Globals.set_map_dimensions.connect(on_set_map_dimensions)
	Globals.day_end.connect(on_day_end)

#Transformation des touche appuyées par le joueur en un vecteur
func _process(_delta):
	direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		set_walking(true) 
		update_blend_position()
	else:
		set_walking(false)

#Mise à jour de l'état du joueur pour animation
func set_walking(value:bool):
	animation_tree["parameters/conditions/is_walking"] = value
	animation_tree["parameters/conditions/is_idle"] = not value

#Mise à jour de l'orientation du joueur pour l'animation
func update_blend_position():
	if direction == Vector2(0, -1):
		if prev_direction == Vector2(0, 1):
			prev_direction = Vector2(1,0)
		animation_tree["parameters/Idle/blend_position"] = prev_direction
		animation_tree["parameters/Walk/blend_position"] = prev_direction
	else:
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Walk/blend_position"] = direction
		prev_direction = direction

# Fonction qui régis le mouvement et la vitesse du joueur.
func _physics_process(_delta):
	velocity = direction * Globals.player_speed
	move_and_slide()

#Mise à jour des limites du monde pour la caméra
func on_set_map_dimensions(dimensions:Rect2i):
	$Camera2D.limit_left = dimensions.position.x * 96
	$Camera2D.limit_top = dimensions.position.y * 96
	$Camera2D.limit_right = dimensions.end.x * 96
	$Camera2D.limit_bottom = dimensions.end.y * 96

#Appelé lorsque la journée se termine, ramène le joueur au campement.
func on_day_end():
	await get_tree().create_timer(1).timeout
	position = Vector2i(15,654)
