extends StaticBody2D

var health:float = 3

func _ready():
	Globals.day_end.connect(on_day_end)

func on_day_end():
	if !Globals.quota_complete:
		health -= 1
		if health > 0:
			$Plane.material.set_shader_parameter("health", health)
		else:
			$Plane.material.set_shader_parameter("health", health)
			Globals.game_lost.emit()
			
