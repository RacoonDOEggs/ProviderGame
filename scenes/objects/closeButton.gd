extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	#connect("pressed", Callable, "_on_CloseButton_pressed")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_CloseButton_pressed():
	#var stringNumber = "42"
	#var integerValue = to_int(stringNumber)
	get_tree().quit()
