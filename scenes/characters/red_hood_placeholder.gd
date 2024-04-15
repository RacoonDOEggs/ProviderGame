extends CharacterBody2D

@export var speed:int = 500 # Vitesse maximale du joueur

func _ready():
	Globals.set_map_dimensions.connect(on_set_map_dimensions)

# Fonction qui régis le mouvement et la vitesse du joueur.
func _process(_delta):
	var direction:Vector2 = Input.get_vector("left", "right", "up", "down")
	
	velocity = direction * Globals.player_speed
	move_and_slide()

func on_set_map_dimensions(dimensions:Rect2i):
	$Camera2D.limit_left = dimensions.position.x * 96
	$Camera2D.limit_top = dimensions.position.y * 96
	$Camera2D.limit_right = dimensions.end.x * 96
	$Camera2D.limit_bottom = dimensions.end.y * 96
	print("on_set_map_dimensions")
	print($Camera2D.limit_left)
	print($Camera2D.limit_top)
	print($Camera2D.limit_right)
	print($Camera2D.limit_bottom)
