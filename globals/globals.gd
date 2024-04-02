extends Node

signal berry_picked(amount:int)
signal herbs_picked(amount:int)
signal wood_picked(amount:int)
signal resistor_picked(amount:int)
signal remove_item(item_id:int)

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

