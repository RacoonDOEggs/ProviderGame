extends TextureRect

#Permet d'ajuster la taille de la zone de réception dans l'éditeur
@export var custom_size:Vector2 = Vector2(0,0)
#Permet de déterminer des groupes de zones de réception pour limiter les endroits où un objet peut être déposé
@export var ID:String = ""

func _ready():
	#Application de la taille déterminée dans l'éditeur
	set_custom_minimum_size(custom_size)
	$Panel.set_custom_minimum_size(custom_size)

func _get_drag_data(at_position):
	
	#liste des données à passer à la zone de réception qui recevra l'objet déplacé
	var data = {}
	data["origin_texture"] = texture
	data["origin_node"] = self
	data["group_id"] = ID
	
	#Création d'une texture qui suivra la souris pour indiquer l'item qui se fair déplacer
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = 1 #Ignore size
	preview_texture.size = custom_size
	var preview = Control.new() #Positionnement de preview_texture
	preview.add_child(preview_texture)
	preview_texture.position = -0.5 * preview_texture.size
	
	#Application de la texture qui suis la souris
	set_drag_preview(preview)
	
	return data

#Vérification que la zone de réception fait parti du groupe de provenance de l'item
func _can_drop_data(at_position, data):
	return data["group_id"] == ID

#Mise à jour des textures de la zone d'origine et de réception
func _drop_data(at_position, data):
	texture = data["origin_texture"]
	data["origin_node"].texture = null
