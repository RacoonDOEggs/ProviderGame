extends DragAndDrop

signal check_light()
var is_dragable: bool = true

func _can_drop_data(_at_position, _data):
	return _data["origin_group_id"] == group_id and _data["origin_texture"] != texture and is_dragable
