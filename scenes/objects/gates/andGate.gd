extends DragAndDrop

func _can_drop_data(_at_position, _data):
	return false

func update_specific_drop_data(_position, _data):
	$Logic_circuit_ui.light_up_end_light()
