extends CanvasLayer

@export var day_time:int = 60

var day_counter:int = 1

func _ready():
	visible = false
	$ColorRect.visible = false
	$Label2.visible = false
	$Label3.visible = false
	Globals.day_start.connect(on_day_start)
	Globals.day_end.connect(on_day_end)
	$Timer.wait_time = day_time

func on_day_start():
	await get_tree().create_timer(0.5).timeout
	visible = true
	while $Timer.time_left > 0:
		$Label.text = formatLabelText($Timer.time_left)
		await get_tree().create_timer(0.2).timeout

func on_day_end():
	$Label2.text = "Jour " + str(day_counter)
	if Globals.quota_complete:
		$Label3.text = "Tous les survivants ont passé la nuit..."
	else:
		$Label3.text = "Certains survivants ne se sont pas réveillés..."
	$AnimationPlayer.play("fade")
	day_counter += 1
	await get_tree().create_timer(1).timeout
	Globals.day_start.emit()

func formatLabelText(time_left:float) -> String:
	var int_time:int = time_left
	var sec:String = str(int_time % 60) if (int_time % 60) >= 10 else "0" + str(int_time % 60)
	var min:String = str(int_time / 60) if int_time / 60 >= 10 else "0" + str(int_time / 60)
	var s:String = min + ":" + sec
	return s
