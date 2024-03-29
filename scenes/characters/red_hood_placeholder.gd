extends CharacterBody2D

@export var max_speed:int = 500
var speed:int = max_speed

# Fonction qui régis le mouvement et la vitesse du joueur.
func _process(_delta):
	var direction:Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()

# Lorsqu'on clique sur la porte (qu'on ouvre le menu des casse-têtes), le joueur ne peut plus bouger.
func _on_plane_door_plane_door_clicked():
	speed = 0 # On arrête le joueur

# Lorsqu'on ferme le menu des casse-têtes, le joueur peut maintenant bouger.
func _on_plane_door_player_can_move():
	speed = max_speed # On redonne le mouvement au joueur.
