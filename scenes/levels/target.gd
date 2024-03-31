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
var can_have_custom_data = "has_custom_data"

# La position globale du joueur par rapport à la scène (Vecteur de Floats).
var player_position:Vector2i = Vector2i.ZERO
var player_direction: Vector2i = Vector2i.ZERO

# La tuile sélectionnée par le joueur en fonction la direction et de la position du joueur. Elle apparaît brillante.
var selected_tile: Vector2i = Vector2i.ZERO
# Les 3 tuiles positionnées par rapport à la direction du joueur.
var tilesArray: Array = [Vector2i.ZERO, Vector2i.ZERO, Vector2i.ZERO]

# Coordonnées ATLAS pour indiquer quelle tuile utiliser dans notre "tilemap".
var atlas_coord_for_herbs_highlight: Vector2i = Vector2i(2,0) # Herbes brillantes.
var atlas_coord_for_berries_highlight: Vector2i = Vector2i(2,2) # Baies brillantes.
var atlas_coord_for_wood_highlight: Vector2i = Vector2i(1,6) # Bois brillants
var atlas_coord_for_herbs: Vector2i = Vector2i(1,0) # Herbes normal.
var atlas_coord_for_berries: Vector2i = Vector2i(1,2) # Baies normal.
var atlas_coord_for_wood: Vector2i = Vector2i(0,6) # Bois normal.
var atlas_coord_for_herbs_farmed: Vector2i = Vector2i(1,1) # On place les herbes coupées.
var atlas_coord_for_berries_farmed: Vector2i = Vector2i(0,2) # On place le buisson sans baies.

# L'identification de la "tilemap" étant 0.
var source_id = 0

func _input(event):
	# La position locale du joueur par rapport au "tilemap" (Vecteur de Integer).
	var tile_player_position: Vector2i = tile_map.local_to_map(player_position)
	
	# Les 4 directions du joueur
	if Input.is_action_just_released("left"):
		var tile1 = tile_player_position + Vector2i(-1,0) # Tuile à gauche.
		var tile2 = tile_player_position + Vector2i(-1,1) # Tuile en bas à gauche.
		var tile3 = tile_player_position + Vector2i(-1,-1) # Tuile en haut à gauche .
		tilesArray = [tile1, tile2, tile3]
		
	else: if Input.is_action_just_released("right"):
		var tile1 = tile_player_position + Vector2i(1,0) # Tuile à droite.
		var tile2 = tile_player_position + Vector2i(1,-1) # Tuile en haut à droite.
		var tile3 = tile_player_position + Vector2i(1,1) # Tuile en bas à droite.
		tilesArray = [tile1, tile2, tile3]
		
	else: if Input.is_action_just_released("up"):
		var tile1 = tile_player_position + Vector2i(0,-1) # Tuile en haut.
		var tile2 = tile_player_position + Vector2i(-1,-1) # Tuile en haut à gauche.
		var tile3 = tile_player_position + Vector2i(1,-1) # Tuile en haut à droite.
		tilesArray = [tile1, tile2, tile3]
		
	else: if Input.is_action_just_released("down"):
		var tile1 = tile_player_position + Vector2i(0,1) # Tuile en bas.
		var tile2 = tile_player_position + Vector2i(-1,1) # Tuile en bas à gauche.
		var tile3 = tile_player_position + Vector2i(1,1) # Tuile en bas à droite.
		tilesArray = [tile1, tile2, tile3]
	
	
	# On vérifie (ans l'ordre de tilesArray) si les tuiles ont des données ou non.
	for i in tilesArray.size():
		 
		# Prend les données de la tuile cliquée.
		var tile_data: TileData = tile_map.get_cell_tile_data(objects_layer, tilesArray[i])
		
		# Si la tuile possède des données
		if tile_data:
			
			# On crée une variable booléenne indiquant si la tuile possède des données personnalisées.
			var has_custom_data: bool = tile_data.get_custom_data(can_have_custom_data)
			
			#Si la tuile possède des données personalisées.
			if has_custom_data:
				
				# On crée des variables booléennes indiquant si la tuile possède des données personnalisées voulues..
				var can_highlight_herbs: bool = tile_data.get_custom_data(can_farm_herbs_custom_data)
				var can_highlight_berries: bool = tile_data.get_custom_data(can_farm_berries_custom_data)
				var can_highlight_wood: bool = tile_data.get_custom_data(can_farm_wood_custom_data)
				
				# On garde en mémoire la tuile qui est brillante.
				selected_tile = tilesArray[i]
				
				# Dépendamment des données personalisées de la tuile sélectionnée, on la fait briller.
				if can_highlight_herbs:
					tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_herbs_highlight)
				else: if can_highlight_berries:
					tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_berries_highlight)
				else: if can_highlight_wood:
					tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_wood_highlight)
				
				
				# 2. Si le joueur pèse sur F pendant que la tuile est brillante.
				if Input.is_action_just_pressed("interact"):
					
					# On crée des variables booléennes indiquant si la tuile possède des données personnalisées voulues..
					var can_farm_herbs: bool = tile_data.get_custom_data(can_farm_herbs_custom_data)
					var can_farm_berries: bool = tile_data.get_custom_data(can_farm_berries_custom_data)
					var can_farm_wood: bool = tile_data.get_custom_data(can_farm_wood_custom_data)
					
					# Dépendamment des données personalisées de la tuile sélectionnée, on la fait briller.
					if can_farm_herbs:
						tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_herbs_farmed)
					else: if can_farm_berries:
						tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_berries_farmed)
					else: if can_farm_wood:
						tile_map.erase_cell(objects_layer, selected_tile)
				
			else: # La tuile n'a pas de données personalisées.
				print("On ne peut pas placer de tuiles ici: Pas de données personalisées")
			
		else: # La tuile n'a pas de données.
			print("On ne peut pas placer de tuiles ici: Pas de données")


# Signal reçu à chaque image par seconde de la scène du personnage pour avoir sa position à chaque image par seconde.
func _on_map_generator_player_pos_signal_2(player_pos):
	player_position = player_pos
