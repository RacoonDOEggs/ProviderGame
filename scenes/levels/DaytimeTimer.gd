extends Timer


func _ready():
	Globals.day_start.connect(on_day_start)

func on_day_start():
	print("timer start")
	start()

func _on_timeout():
	Globals.day_end.emit()
