extends CharacterBody2D

@export var max_speed:int = 500 # Vitesse maximale du joueur
var speed:int = max_speed # Vitesse du joueur

# Fonction qui régis le mouvement et la vitesse du joueur.
func _process(_delta):
	var direction:Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if Globals.player_can_move == true:
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
	

# Lorsqu'on clique sur la porte (qu'on ouvre le menu des casse-têtes), le joueur ne peut plus bouger.
func _on_plane_door_plane_door_clicked():
	Globals.player_can_move = false
