#AUTEUR :  Rime Elbraoudi et Marc-Olivier Beaulieu
#PROJET : Provider
#NOM DU FICHIER : empty_gate.gd (toutes les empty_gates ont le même code)
#DESCRIPTION : logique pour les portes et les ombres (drag and drop)
extends DragAndDrop

signal check_light
var is_dragable: bool = true

#Cette fonction sert à rendre les nodes possible pour des objets drag d'être déposé dessus
func _drop_data(_at_position, data):
	if data["origin_node"] != self: #Évite un problème où l'objet disparait si il est déposé sur lui même
		check_light.emit()
		if data["origin_object_value"] != 0:
			data["origin_node"].texture = null
			data["origin_node"].object_id = 0
		texture = data["origin_texture"]
		object_id = data["origin_object_id"]
		return data["origin_group_id"] == group_id and data["origin_texture"] != texture and is_dragable
