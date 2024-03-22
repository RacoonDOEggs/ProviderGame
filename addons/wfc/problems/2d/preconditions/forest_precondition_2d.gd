extends WFC2DPrecondition
class_name WFC2DPreconditionForest

var forest_set: WFCBitSet
var dirt_set: WFCBitSet
var water_set: WFCBitSet

var seed: int
var dirt_threshold: float
var water_threshold: float

var rect: Rect2i
var state: PackedByteArray

var moisture: FastNoiseLite = FastNoiseLite.new()

## Initialize this precondition.
## [br]
## Must be called at most once on one object.
func prepare():
	assert(rect.has_area())
	state.resize(rect.get_area())

	moisture.noise_type = FastNoiseLite.TYPE_SIMPLEX
	moisture.seed = seed



## Returns initial domain of a cell at given coordinates.
## [br]
## Returns null if this precondition doesn't limit domain of cell at given coordinates.
## [br]
## Must not be called before completion of prepare() call.
func read_domain(coords: Vector2i) -> WFCBitSet:
	assert(state.size() == rect.get_area())

	var moist = moisture.get_noise_2d(coords.x, coords.y)
	if moist > water_threshold:
		return water_set
	elif moist < dirt_threshold:
		return dirt_set
	else:
		return forest_set


func learn_classes_from_map(mapper: WFCMapper2D,map: Node,):
	assert(mapper.supports_map(map))

	var used_rect := mapper.get_used_rect(map)

	assert(used_rect.has_area())
	# 1 row: all forest tiles
	# 2 rows: 1st row is forest, 2nd row is dirt tiles
	# 3 rows: 1st row is forest, 2nd row is dirt tiles and 3rd is water
	assert(used_rect.size.y == 1 or used_rect.size.y == 2 or used_rect.size.y == 3)

	forest_set = WFCBitSet.new(mapper.size())
	
	for x_off in range(used_rect.size.x):
		var p := used_rect.position + Vector2i(x_off,0)
		var tile := mapper.read_cell(map, p)
		if tile >= 0:
			forest_set.set_bit(tile)
	
	if used_rect.size.y == 1:
		dirt_set = null
		water_set = null
	elif used_rect.size.y == 2:
		dirt_set = WFCBitSet.new(mapper.size())
		water_set = null
		for x_off in range(used_rect.size.x):
			var p := used_rect.position + Vector2i(x_off,1)
			var tile := mapper.read_cell(map, p)
			if tile >= 0:
				dirt_set.set_bit(tile)
		
		assert(not dirt_set.is_empty())
	else:
		dirt_set = WFCBitSet.new(mapper.size())
		water_set = WFCBitSet.new(mapper.size())

		for x_off in range(used_rect.size.x):
			var p := used_rect.position + Vector2i(x_off,1)
			var tile := mapper.read_cell(map, p)
			if tile >= 0:
				dirt_set.set_bit(tile)
			p = used_rect.position + Vector2i(x_off,2)
			tile = mapper.read_cell(map, p)
			if tile >= 0:
				water_set.set_bit(tile)

		assert(not dirt_set.is_empty() and not water_set.is_empty())
