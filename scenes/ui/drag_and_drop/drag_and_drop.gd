extends TextureRect
class_name DragAndDrop

#Permet d'ajuster la taille de la zone de réception dans l'éditeur
@export var custom_size:Vector2 = Vector2(0,0)
#Permet de déterminer des groupes de zones de réception pour limiter les endroits où un objet peut être déposé
@export var group_id:String = ""
#Permet d'assigner une valeur à l'objet dans l'éditeur
@export var object_value:float = 0
#Permet d'assigner un code d'objet à l'objet dans l'éditeur
@export var object_id:int = -1

#S'exécute à la création de l'objet
func _ready():
	#Application de la taille déterminée dans l'éditeur
	set_custom_minimum_size(custom_size)
	$Panel.set_custom_minimum_size(custom_size)
	specific_ready()

#Permet d'exécuter du code spécifique à une classe héritante à la création
func specific_ready():
	pass

func _get_drag_data(_at_position):
	
	#liste des données à passer à la zone de réception qui recevra l'objet déplacé
	var data = {}
	data["origin_texture"] = texture
	data["origin_node"] = self
	data["origin_group_id"] = group_id
	data["origin_object_value"] = object_value
	data["origin_object_id"] = object_id
	data = specific_drag_data(data)
	
	#Création d'une texture qui suivra la souris pour indiquer l'item qui se fair déplacer
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = 1 #Ignore size
	preview_texture.size = custom_size
	preview_texture = specific_preview(preview_texture)
	var preview = Control.new()  #Positionnement de preview_texture
	preview.add_child(preview_texture)
	preview_texture.position = -0.5 * preview_texture.size
	
	#Application de la texture qui suis la souris
	set_drag_preview(preview)
	
	return data

func specific_drag_data(data):
	return data

func specific_preview(preview_texture: TextureRect) -> TextureRect:
	return preview_texture

#Vérification que la zone de réception fait parti du groupe de provenance de l'item
func _can_drop_data(_at_position, data):
	return data["origin_group_id"] == group_id

#Mise à jour des textures de la zone d'origine et de réception
func _drop_data(at_position, data):
	if data["origin_node"] != self: #Évite un problème où l'objet disparait si il est déposé sur lui même
		texture = data["origin_texture"]
		data["origin_node"].texture = null
		object_value = data["origin_object_value"]
		#var temp_id = object_id
		object_id = data["origin_object_id"]
		#data["origin_node"].object_id = temp_id
		data["origin_node"].object_id = -1
		data["origin_node"].object_value = -1
		update_specific_drop_data(at_position, data)
	
	

#Permet d'exécuter du code spécifique à une classe héritante lorsqu'un objet est déposé dans la zone de réception
func update_specific_drop_data(_at_position, _data):
	pass
