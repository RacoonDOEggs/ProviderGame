#AUTEUR : Marc-Olivier Beaulieu
#PROJET : Provider
#NOM DU FICHIER : map_generator.gd
#DESCRIPTION : Intérragit avec le plugin de Wave Function Collapse pour générer le monde et place le vieux crash d'avion à un endroit aléatoire.
extends Node2D

#Dimensions du monde et de la zone du vieux crash
@export var generation_size:Vector2i = Vector2i(200,200)
@export var crash_area:Vector2i = Vector2i(10,10)

var rng = RandomNumberGenerator.new()
var old_plane = preload("res://scenes/objects/old_plane.tscn").instantiate()
var crash_pos:Vector2i

func _on_start():
	Globals.player_speed = 0 # Le joueur ne peut pas se déplacer.
	$Waiting_screen.show()
	self.add_child(old_plane)
	crash_pos = generate_plane_crashes()
	$WFC2DGenerator.rect = Rect2i(Vector2i(-(generation_size.x/2), -(generation_size.y/2)), generation_size)
	$sample.hide()
	$negative_sample.hide()
	$target.show()
	$WFC2DGenerator.start()

#Choisis l'emplacement du vieux crash et réserve son emplacement
func generate_plane_crashes():
	rng.randomize()
	var crash_coords:Vector2i
	while (crash_coords.x < 100 and crash_coords.x > -100 and crash_coords.y < 100 and crash_coords.y > -100):
		crash_coords = Vector2i(-(generation_size.x/2), -(generation_size.y/2)) + Vector2i(rng.randi()%(generation_size.x - crash_area.x), rng.randi()%(generation_size.y-crash_area.y))
	print("placing tiles at")
	print(crash_coords)
	$OldPlane.position = $target.map_to_local(crash_coords + crash_area/2)
	for x in range(crash_coords.x,crash_coords.x+crash_area.x):
		for y in range(crash_coords.y, crash_coords.y+crash_area.y):
			$target.set_cell(1,Vector2i(x,y),0,Vector2i(0,1))
			$target.set_cell(0,Vector2i(x,y),0,Vector2i.ZERO)
	return crash_coords

#Place le vieux crash et supprime les échantillons de la génération
func _on_wfc_2d_generator_done():
	Globals.set_map_dimensions.emit($WFC2DGenerator.rect)
	$sample.queue_free()
	$negative_sample.queue_free()
	for x in range(crash_pos.x,crash_pos.x+crash_area.x):
		for y in range(crash_pos.y, crash_pos.y+crash_area.y):
			$target.erase_cell(1,Vector2i(x,y))
	for x in range($WFC2DGenerator.rect.position.x - 1, $WFC2DGenerator.rect.end.x + 1):
		$target.set_cell(0,Vector2i(x,$WFC2DGenerator.rect.position.y - 1),0,Vector2i(2,1))
		$target.set_cell(0,Vector2i(x,$WFC2DGenerator.rect.end.y + 1),0,Vector2i(2,1))
	for y in range($WFC2DGenerator.rect.position.y - 1, $WFC2DGenerator.rect.end.y + 1):
		$target.set_cell(0,Vector2i($WFC2DGenerator.rect.position.x - 1,y),0,Vector2i(2,1))
		$target.set_cell(0,Vector2i($WFC2DGenerator.rect.end.x + 1,y),0,Vector2i(2,1))

