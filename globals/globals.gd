extends Node


var laser_timer_check: bool = false:
	get:
		return laser_timer_check
	set(value):
		laser_timer_check = value


var angles_value: float:
	get:
		return angles_value
	set(value):
		angles_value = value
