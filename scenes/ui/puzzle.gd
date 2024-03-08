extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_ButtonX_pressed():
	print ('ButtonX is clicked')
	#connect doors and strings 
	
func _on_ButtonY_pressed():
	print('ButtonY is clicked')
	#connect rest
	
func _on_ButtonZ_pressed():
	print('ButtonZ is clicked')
	#connect rest

#func _on_CloseButton_pressed(event):
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#get_tree().quit()
	
