extends DragAndDrop

func _can_drop_data(_at_position, _data):
	return object_id == -1

func update_specific_drop_data(_at_position, data):
	update_stack_label()
	data["origin_node"].update_stack_label()

func update_stack_label():
	$Label.text = str(object_value) if object_value > 0 else "" 
