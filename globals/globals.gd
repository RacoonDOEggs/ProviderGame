extends Node

signal berry_picked(amount:int)
signal herbs_picked(amount:int)
signal wood_picked(amount:int)
signal resistor_picked(amount:int)

signal cashout

signal remove_item(item_id:int, status:Array)
signal item_placed(item_id:int, status:bool)

signal inventory_full()

signal set_map_dimensions(dimensions:Rect2i)

var resistors_acquired:bool = false:
	get:
		return resistors_acquired
	set(value):
		resistors_acquired = value

var player_direction: String = "":
	get:
		return player_direction
	set(value):
		player_direction = value


var laser_timer_check: bool = false:
	get:
		return laser_timer_check
	set(value):
		laser_timer_check = value


var player_pos: Vector2 = Vector2.ZERO:
	get:
		return player_pos
	set(value):
		player_pos = value

var player_speed: int = 500:
	get:
		return player_speed
	set(value):
		player_speed = value

var game_won: bool = false:
	get:
		return game_won
	set(value):
		game_won = value

var end_game: bool = false:
	get:
		return end_game
	set(value):
		end_game = value
