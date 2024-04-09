extends StaticBody2D

var mouse_is_inside:bool = false

func _on_mouse_exited():
	$OldPlaneSprite.modulate = Color(1.0,1.0,1.0,1.0)
	mouse_is_inside = false

func _on_mouse_entered():
	$OldPlaneSprite.modulate = Color(1.1,1.1,1.1,1.0)
	mouse_is_inside = true

func _unhandled_input(event):
	if event.is_action_pressed("clicked") and mouse_is_inside:
		Globals.resistor_picked.emit(3)
		self.input_pickable = false
