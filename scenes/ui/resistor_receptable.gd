extends DragAndDrop

func update_specific_drop_data(_at_position, data):
	$Label.text = str(data["origin_object_value"])
	data["origin_node"].get_child(1).text = ""
