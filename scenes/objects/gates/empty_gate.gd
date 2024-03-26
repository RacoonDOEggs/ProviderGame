extends DragAndDrop


func _drop_data(_at_position, data):
	if data["origin_node"] != self: #Évite un problème où l'objet disparait si il est déposé sur lui même
		if data["origin_object_value"] != 0:
			data["origin_node"].texture = null
			data["origin_node"].object_id = 0
		texture = data["origin_texture"]
		object_id = data["origin_object_id"]
