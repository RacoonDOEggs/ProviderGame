extends DragAndDrop

func specific_ready():
	$Label.text = str(object_value)

func update_specific_drop_data(_at_position, data):
	$Label.text = str(data["origin_object_value"])
	data["origin_node"].get_child(1).text = ""
