#AUTEUR :  Rime Elbraoudi et Marc-Olivier Beaulieu
#PROJET : Provider
#NOM DU FICHIER : andGate.gd (toutes les gates ont le même code)
#DESCRIPTION : logique pour les portes et les ombres (drag and drop)
extends DragAndDrop

signal check_light()
var is_dragable: bool = true

#Cette fonction sert à rendre les portes « dragable » et possible de déposer sur des objets aussi implémentés 
#avec la classe DragAnddrop
func _can_drop_data(_at_position, _data):
	return _data["origin_group_id"] == group_id and _data["origin_texture"] != texture and is_dragable
