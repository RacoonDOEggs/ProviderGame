extends DragAndDrop


func _drop_data(_at_position, data):
	if data["origin_node"] != self: #Évite un problème où l'objet disparait si il est déposé sur lui même
		texture = data["origin_texture"]
		object_value = data["origin_object_value"]
		object_id = data["origin_object_id"]
