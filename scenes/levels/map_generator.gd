extends Node2D

@export var generation_size:Vector2i = Vector2i(200,200)
@export var crash_area:Vector2i = Vector2i(20,20)
@export var crash_amount:int = 4



func _ready():
	$WFC2DGenerator.rect = Rect2i(Vector2i(-(generation_size.x/2), -(generation_size.y/2)), generation_size)
	$sample.hide()
	$negative_sample.hide()
	$target.show()
	generate_plane_crashes()
	$WFC2DGenerator.start()
	

func generate_plane_crashes():
	var generaton_rect = $WFC2DGenerator.rect
	randomize()
	var i:int = 0
	while i < crash_amount:
		var crash_coords:Vector2i = Vector2i(randi()%(generaton_rect.size.x - crash_area.x), randi()%(generaton_rect.size.y-crash_area.y))
		if ($target.get_cell_source_id(0,crash_coords, false) == -1 
		and $target.get_cell_source_id(0,Vector2i(crash_coords.x + crash_area.x, crash_coords.y+crash_area.y), false) == -1
		and $target.get_cell_source_id(0,Vector2i(crash_coords.x, crash_coords.y+crash_area.y), false) == -1
		and $target.get_cell_source_id(0,Vector2i(crash_coords.x + crash_area.x, crash_coords.y), false) == -1):
			print("placing tiles at")
			print(crash_coords)
			for x in range(crash_coords.x,crash_coords.x+crash_area.x):
				for y in range(crash_coords.y, crash_coords.y+crash_area.y):
					$target.set_cell(0,Vector2i(x,y), 0, Vector2i(0,0))
			i+=1
		else:
			i -= 1


func _on_wfc_2d_generator_done():
	$sample.queue_free()
	$negative_sample.queue_free()
