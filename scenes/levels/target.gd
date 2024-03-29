# Source pour le remplacement de tuile dans le jeu:https://www.youtube.com/watch?v=4ezSpnuvZfE
extends TileMap

@onready var tile_map = $"."

# Variables indiquant les couches du "tilemap".
var ground_layer = 0
var objects_layer = 1
var farmed_objects_layer = 2

# Variables indiquant les différentes données personalisées.
var can_farm_herbs_custom_data = "can_farm_herbs"
var can_farm_berries_custom_data = "can_farm_berries"
var can_farm_wood_custom_data = "can_farm_wood"

# La position globale du joueur par rapport à la scène (Vecteur de Floats).
var player_position = null 

func _input(event):
	# Si on appuie sur le bouton f.
	
	var player_direction = Input.get_vector("left", "right", "up", "down")
	
	
	if Input.is_action_just_pressed("interact"):
		# La position locale du joueur par rapport au "tilemap" (Vecteur de Integer).
		var tile_player_position: Vector2i = tile_map.local_to_map(player_position)
		print(tile_player_position)
		var tile_player_direction: Vector2i = tile_map.local_to_map(player_direction)
		
		var selected_tile = tile_player_position + tile_player_direction
		print(selected_tile)
		## La position globale de la souris par rapport à la scène (Vecteur de Floats).
		#var mouse_pos : Vector2 = get_global_mouse_position()
		## La position locale de la souris par rapport au "tilemap" (Vecteur de Integer).
		#var tile_mouse_pos: Vector2i = tile_map.local_to_map(mouse_pos)
		
		# L'identification de la "tilemap" étant 0.
		var source_id = 0
		
		# Coordonnées ATLAS pour indiquer quelle tuile utiliser dans notre "tilemap".
		var atlas_coord_for_herbs: Vector2i = Vector2i(1,1) # On place les herbes coupées.
		var atlas_coord_for_berries: Vector2i = Vector2i(0,2) # On place le buisson sans baies.
		var atlas_coord_for_wood: Vector2i = Vector2i(0,0) # On place la tuile d'herbe.
		
		# Prend les données de la tuile cliquée.
		var tile_data: TileData = tile_map.get_cell_tile_data(objects_layer, selected_tile)
		
		# On vérifie si la tuile cliquée a des données ou non.
		if tile_data:
			# On crée des variables booléennes indiquant si la tuile possède les données personalisées que l'on veux.
			var can_farm_herbs: bool = tile_data.get_custom_data(can_farm_herbs_custom_data)
			var can_farm_berries: bool = tile_data.get_custom_data(can_farm_berries_custom_data)
			var can_farm_wood: bool = tile_data.get_custom_data(can_farm_wood_custom_data)
			
			#Si les variables sont vraies, on place la nouvelle tuile sur l'ancienne tuile qui permet le remplacement de tuiles.
			if can_farm_herbs:
				tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_herbs)
			else: if can_farm_berries:
				tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_berries)
			else: if can_farm_wood:
				tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_wood)
			else:
				print("On ne peut pas placer de tuiles ici: Pas les bonnes données personalisées")
		else:
			print("On ne peut pas placer de tuiles ici: Pas de données")

func _on_map_generator_player_pos_signal_2(player_pos):
	player_position = player_pos
