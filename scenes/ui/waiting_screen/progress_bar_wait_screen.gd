extends CanvasLayer

@export
var generator_progress_bar: WFC2DGenerator

var start_time: int = 0

func _ready():
	%TextureProgressBar.min_value = 0
	%TextureProgressBar.max_value = 1.0
	%TextureProgressBar.step = 0.001

func _process(delta):
	%TextureProgressBar.value = generator_progress_bar.get_progress()
