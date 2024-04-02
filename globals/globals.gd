extends Node


var laser_timer_check: bool = false:
	get:
		return laser_timer_check
	set(value):
		laser_timer_check = value


var player_pos: Vector2i = Vector2i.ZERO:
	get:
		return player_pos
	set(value):
		player_pos = value
