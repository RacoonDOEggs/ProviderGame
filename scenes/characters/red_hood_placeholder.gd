extends CharacterBody2D

@export var max_speed:int = 500
var speed:int = max_speed

# Fonction qui régis le mouvement et la vitesse du joueur.
func _process(_delta):
	var direction:Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
