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
var player_position = Vector2i.ZERO
var player_direction: Vector2i = Vector2i.ZERO



func _input(event):
	# Prend en note la dernière direction du joueur pour savoir dans quel direction il pointe.
	if Input.is_action_just_released("left"):
		player_direction = Vector2i(-1,0)
	else: if Input.is_action_just_released("right"):
		player_direction = Vector2i(1,0)
	else: if Input.is_action_just_released("up"):
		player_direction = Vector2i(0,-1)
	else: if Input.is_action_just_released("down"):
		player_direction = Vector2i(0,1)
	
	
	# La position locale du joueur par rapport au "tilemap" (Vecteur de Integer).
	var tile_player_position: Vector2i = tile_map.local_to_map(player_position)
	# L tuile sélectionnée par le joueur en fonction la direction et de la position du joueur (Un rayon de 1 tuile)
	var selected_tile = tile_player_position + player_direction
	
	# Coordonnées ATLAS pour indiquer quelle tuile utiliser dans notre "tilemap".
	var atlas_coord_for_herbs_highlight: Vector2i = Vector2i(2,0) # Herbes brillantes.
	var atlas_coord_for_berries_highlight: Vector2i = Vector2i(2,2) # Baies brillantes.
	var atlas_coord_for_wood_highlight: Vector2i = Vector2i(1,6) # Bois brillants
	var atlas_coord_for_herbs: Vector2i = Vector2i(1,0) # Herbes normales.
	var atlas_coord_for_berries: Vector2i = Vector2i(1,2) # Baies normales.
	var atlas_coord_for_wood: Vector2i = Vector2i(0,6) # Bois normales

	# Prend les données de la tuile cliquée.
	var tile_data: TileData = tile_map.get_cell_tile_data(objects_layer, selected_tile)
	
	# L'identification de la "tilemap" étant 0.
	var source_id = 0
	
	# On vérifie si la tuile cliquée a des données ou non.
	if tile_data:
		# On crée des variables booléennes indiquant si la tuile possède les données personalisées que l'on veux.
		var can_highlight_herbs: bool = tile_data.get_custom_data(can_farm_herbs_custom_data)
		var can_highlight_berries: bool = tile_data.get_custom_data(can_farm_berries_custom_data)
		var can_highlight_wood: bool = tile_data.get_custom_data(can_farm_wood_custom_data)
		
		#Si les variables sont vraies, on change de tuile sur l'ancienne tuile.
		if can_highlight_herbs:
			tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_herbs_highlight)
		else: if can_highlight_berries:
			tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_berries_highlight)
		else: if can_highlight_wood:
			tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_wood_highlight)
		else:
			print("On ne peut pas placer de tuiles ici: Pas les bonnes données personalisées")
		
		
		# Si on appuie sur f directement 
		if Input.is_action_just_pressed("interact"):
			# Coordonnées ATLAS pour indiquer quelle tuile utiliser dans notre "tilemap".
			var atlas_coord_for_herbs_farmed: Vector2i = Vector2i(1,1) # On place les herbes coupées.
			var atlas_coord_for_berries_farmed: Vector2i = Vector2i(0,2) # On place le buisson sans baies.
			
			# On vérifie si la tuile cliquée a des données ou non.
			if tile_data:
				# On crée des variables booléennes indiquant si la tuile possède les données personalisées que l'on veux.
				var can_farm_herbs: bool = tile_data.get_custom_data(can_farm_herbs_custom_data)
				var can_farm_berries: bool = tile_data.get_custom_data(can_farm_berries_custom_data)
				var can_farm_wood: bool = tile_data.get_custom_data(can_farm_wood_custom_data)
				
				#  Les variables sont vraies, on place la nouvelle tuile sur l'ancienne tuile qui permet le remplacement de tuiles.
				if can_farm_herbs:
					tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_herbs_farmed)
				else: if can_farm_berries:
					tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_berries_farmed)
				else: if can_farm_wood:
					tile_map.erase_cell(objects_layer, selected_tile)
				else: # Les variables sont tous fausses.
					print("On ne peut pas placer de tuiles ici: Pas les bonnes données personalisées")
				
			else: # La tuile n'a pas de donées.
				print("On ne peut pas placer de tuiles ici: Pas de données")
			
		else: # Le joueur n'a pas appuyé sur "interact", on replace les anciennes tuiles normales.
			pass
		
	else: # La tuile n'a pas de donées.
		print("On ne peut pas placer de tuiles ici: Pas de données")


func _on_map_generator_player_pos_signal_2(player_pos):
	player_position = player_pos
