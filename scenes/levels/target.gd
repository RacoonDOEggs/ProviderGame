#AUTEUR :  Xavier Bilodeau et Marc-Oliver Beaulieu
#PROJET : Provider
#NOM DU FICHIER : target.gd
#DESCRIPTION : S'occupe du ramassage d'items dans la carte.

# Source pour le remplacement de tuile dans le jeu:https://www.youtube.com/watch?v=4ezSpnuvZfE
extends TileMap

@onready var tile_map = $"."

# La tuile sélectionnée par le joueur en fonction la direction et de la position du joueur. Elle apparaît brillante.
var selected_tile: Vector2i = Vector2i.ZERO

# La position locale du joueur par rapport au "tilemap" (Vecteur de Integer)
var tile_player_position: Vector2i = Vector2i.ZERO

# Les 3 tuiles positionnées par rapport à la direction du joueur.
var tilesArray = [Vector2i.ZERO, Vector2i.ZERO, Vector2i.ZERO, Vector2i.ZERO, Vector2i.ZERO, Vector2i.ZERO, Vector2i.ZERO, Vector2i.ZERO]

# Variables indiquant les couches du "tilemap".
const ground_layer = 0
var objects_layer = 1
var farmed_objects_layer = 2

# Variables indiquant les différentes données personalisées.
var can_farm_herbs_custom_data = "can_farm_herbs"
var can_farm_berries_custom_data = "can_farm_berries"
var can_farm_wood_custom_data = "can_farm_wood"
var can_have_custom_data = "has_custom_data"

# Variables booléennes indiquant si la tuile possède des données personnalisées voulues..
var can_highlight_herbs: bool = false
var can_highlight_berries: bool = false
var can_highlight_wood: bool = false

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

func _ready():
	Globals.item_placed.connect(change_cell_to_harvested)

func _process(delta):
	# On fait la conversion de la position globale du joueur par rapport à celle locale.
	tile_player_position = tile_map.local_to_map(Globals.player_pos)
	
	var left_tile = tile_player_position + Vector2i(-1,0)
	var right_tile = tile_player_position + Vector2i(1,0)
	var up_tile = tile_player_position + Vector2i(0,-1)
	var down_tile = tile_player_position + Vector2i(0,1)
	var up_left_tile = tile_player_position  + Vector2i(-1,-1)
	var down_left_tile = tile_player_position + Vector2i(-1,1)
	var up_right_tile = tile_player_position + Vector2i(1,-1)
	var down_right_tile = tile_player_position + Vector2i(1,1)
	
	# Selon la direction, on établit un tableau des tuiles autour du joueur.
	if Globals.player_direction == "left":
		# On associe, en ordre par rapport à la direction, les tuiles à vérifier.
		tilesArray = [tile_player_position, left_tile, down_left_tile, up_left_tile, up_tile, down_tile, up_right_tile, down_left_tile]
	elif Globals.player_direction == "right":
		# On associe, en ordre par rapport à la direction, les tuiles à vérifier.
		tilesArray = [tile_player_position, right_tile, up_right_tile, down_right_tile, up_tile, down_tile, up_left_tile, down_left_tile]
	elif Globals.player_direction == "up":
		# On associe, en ordre par rapport à la direction, les tuiles à vérifier.
		tilesArray = [tile_player_position, up_tile, up_left_tile, up_right_tile, left_tile, right_tile, down_left_tile, down_right_tile]
	elif Globals.player_direction == "down":
		# On associe, en ordre par rapport à la direction, les tuiles à vérifier.
		tilesArray = [tile_player_position, down_tile, down_left_tile, down_right_tile, left_tile, right_tile, up_right_tile, up_left_tile]
	
	# Variable compteur pour la boucle.
	var i: int = 0
	# Tant qu'il n'y a pas de tuile avec des données personalisées.
	while selected_tile == Vector2i.ZERO and i < 8:
		# Prend les données d'une des 3 tuiles devant le joueur.
		var tile_data: TileData = tile_map.get_cell_tile_data(objects_layer, tilesArray[i])
		
		# Si la tuile a des données.
		if tile_data:
			# On crée une variable booléenne indiquant si la tuile possède des données personnalisées.
			var has_custom_data: bool = tile_data.get_custom_data(can_have_custom_data)
			
			# Si la tuile a des données personalisées.
			if has_custom_data:
				
				# On la garde en mémoire.
				selected_tile = tilesArray[i]
				
				# On crée des variables booléennes indiquant si la tuile possède des données personnalisées voulues..
				can_highlight_herbs = tile_data.get_custom_data(can_farm_herbs_custom_data)
				can_highlight_berries = tile_data.get_custom_data(can_farm_berries_custom_data)
				can_highlight_wood = tile_data.get_custom_data(can_farm_wood_custom_data)
				
				# Dépendamment des données personalisées de la tuile sélectionnée, on la fait briller.
				if can_highlight_herbs:
					tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_herbs_highlight)
				else: if can_highlight_berries:
					tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_berries_highlight)
				else: if can_highlight_wood:
					tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_wood_highlight)
		# On augmente le compteur de 1.
		i += 1
	
	# S'il y a une tuile sélectionnée brillante.
	if selected_tile != Vector2i.ZERO:
		
		# La distance entre le joueur et la tuile sélectionnée sous forme de vecteur de Integer.
		var distance_tuile_joueur_vector: Vector2i = abs(tile_player_position - selected_tile) # Distance entre la tuile brillante et le joueur.
		# La distance entre le joueur et la tuile sous forme de distance Integer.
		var distance_tuile_joueur_squarred = distance_tuile_joueur_vector.length()
		
		
		#Si le joueur sort d'un rayon de 1 bloc, on arrête le brillement.	
		if distance_tuile_joueur_squarred > 1.5:
			# Prend les données de la tuile brillante.
			var tile_data: TileData = tile_map.get_cell_tile_data(objects_layer, selected_tile)
			
			# On crée des variables booléennes indiquant si la tuile possède des données personnalisées voulues..
			can_highlight_herbs = tile_data.get_custom_data(can_farm_herbs_custom_data)
			can_highlight_berries = tile_data.get_custom_data(can_farm_berries_custom_data)
			can_highlight_wood = tile_data.get_custom_data(can_farm_wood_custom_data)
			
			# Dépendamment des données personalisées de la tuile sélectionnée, on enlève le brillement.
			if can_highlight_herbs:
				tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_herbs)
			else: if can_highlight_berries:
				tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_berries)
			else: if can_highlight_wood:
				tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_wood)
			
			# Il n'y a plus de tuile sélectionnée.
			selected_tile = Vector2i.ZERO


func _input(_event):
	#Les 4 directions du joueur. On détermine la direction du joueur.
	if Input.is_action_just_pressed("left"):
		Globals.player_direction = "left"
	else: if Input.is_action_just_pressed("right"):
		Globals.player_direction = "right"
	else: if Input.is_action_just_pressed("up"):
		Globals.player_direction = "up"
	else: if Input.is_action_just_pressed("down"):
		Globals.player_direction = "down"
	
	
	# Si le joueur appuie sur F et qu'il y a une tuile de sélectionnée.
	if Input.is_action_pressed("interact") and selected_tile != Vector2i.ZERO:
		
		# Prend les données de la tuile brillante.
		var tile_data: TileData = tile_map.get_cell_tile_data(objects_layer, selected_tile)
		
		# On crée des variables booléennes indiquant si la tuile possède des données personnalisées voulues..
		var can_farm_herbs: bool = tile_data.get_custom_data(can_farm_herbs_custom_data)
		var can_farm_berries: bool = tile_data.get_custom_data(can_farm_berries_custom_data)
		var can_farm_wood: bool = tile_data.get_custom_data(can_farm_wood_custom_data)
		
		# Dépendamment des données personalisées de la tuile sélectionnée, on change les tuiles pour indiquer que l'item a été ramassé.
		if can_farm_herbs:
			Globals.herbs_picked.emit(1) # On ajoute l'item d'herbe dans l'inventaire.
		else: if can_farm_berries:
			Globals.berry_picked.emit(1) # On ajoute l'item d'herbe dans l'inventaire.
		else: if can_farm_wood:
			Globals.wood_picked.emit(1) # On ajoute l'item de bois dans l'inventaire.


func change_cell_to_harvested(item_id:int, status:bool):
	# Dépendamment des données personalisées de la tuile sélectionnée, on change les tuiles pour indiquer que l'item a été ramassé.
	
	# S'il n'y a plus de place dans l'inventaire, on indique que l'inventaire est pleine.
	if status == false:
		Globals.inventory_full.emit()
	elif item_id == 1 and status:
		tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_herbs_farmed) 
		# Il n'y a plus de tuile sélectionnée.
		selected_tile = Vector2i.ZERO
	elif item_id == 0 and status:
		tile_map.set_cell(objects_layer, selected_tile, source_id, atlas_coord_for_berries_farmed)
		# Il n'y a plus de tuile sélectionnée.
		selected_tile = Vector2i.ZERO
	elif item_id == 2 and status:
		tile_map.erase_cell(objects_layer, selected_tile)
		# Il n'y a plus de tuile sélectionnée.
		selected_tile = Vector2i.ZERO
