extends DragAndDrop

func _can_drop_data(_at_position, _data):
	return object_id == -1