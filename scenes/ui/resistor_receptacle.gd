extends DragAndDrop

#0 (x1) Black = #000000
#1 (x10) Brown = #512627
#2 (x100) Red = #cc0000
#3 (x1 000) Orange = #d87347
#4 (x10 000)Yellow = #e6c951
#5 (x100 000)Green = #528f65
#6 (x1 000 000)Blue = #0f5190
#7 (x10 000 000)Violet = #6967ce
#8 (x100 000 000)Grey = #7d7d7d
#9 (x1 000 000 000)White = #ffffff
#  (x0.1)Gold = #c08327
#  (x0.01)Silver = #bfbebf

func specific_ready():
	if texture != null:
		$Label.text = str(object_value)
		$MarginContainer/EditButton.visible = true

func update_specific_drop_data(_at_position, data):
	$Label.text = str(data["origin_object_value"])
	data["origin_node"].get_child(1).text = ""
	data["origin_node"].get_child(2).get_child(0).visible = false
	$MarginContainer/EditButton.visible = true

func _on_edit_button_pressed():
	print("edit_resistor")
