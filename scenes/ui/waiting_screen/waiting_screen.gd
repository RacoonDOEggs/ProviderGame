extends CanvasLayer

@export var generator:WFC2DGenerator

func _ready():
	$Progress_bar_wait_screen.generator_progress_bar = generator
