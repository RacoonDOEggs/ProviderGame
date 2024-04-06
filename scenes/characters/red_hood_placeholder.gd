extends CharacterBody2D

@export var speed:int = 500 # Vitesse maximale du joueur

func _ready():
	Globals.player_speed = speed

# Fonction qui régis le mouvement et la vitesse du joueur.
func _process(_delta):
	var direction:Vector2 = Input.get_vector("left", "right", "up", "down")
	
	velocity = direction * Globals.player_speed
	move_and_slide()
