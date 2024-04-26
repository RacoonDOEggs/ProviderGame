extends DragAndDrop


@export var gate_specific_property: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#Application de la taille déterminée dans l'éditeur
	#set_custom_minimum_size(custom_size)
	#initial_position = position
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# This function is called when the drag operation ends
func _on_drag_ended():
	print("Drag operation ended for gate:", get_name(), "with object_id:", object_id)

	#mit the custom signal to indicate the end of the drag operation
	#emit_signal("_on_gate_drag_ended")
	emit_signal("drag_ended")


