extends StaticBody2D

func _ready():
	Globals.day_end.connect(on_day_end)

func on_day_end():
	if !Globals.quota_complete:
		if $BandAid3.visible:
			$BandAid3.visible = false
		elif $BandAid2.visible:
			$BandAid2.visible = false
		elif $BandAid.visible:
			$BandAid.visible = false
		else:
			Globals.end_game = true
			Globals.game_end.emit()