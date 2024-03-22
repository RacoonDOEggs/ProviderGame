extends WFC2DPrecondition2DNullSettings
class_name WFC2DPreconditionForestSettings

@export var seed: int = -1
@export var dirt_threshold: float = 0.2
@export var water_threshold: float = 0.8

## If set, the precondition will extract tile classes (forest/dirt/water) from a map node instead of
## tile meta attributes.
## 
## First row of the map should contain all forest tiles.
## Second row should contain all dirt tiles.
## Third row should contain all water tiles.
@export_node_path
var classes_map: NodePath

func create_precondition(parameters:WFC2DPrecondition2DNullSettings.CreationParameters)-> WFC2DPrecondition:
    var res: WFC2DPreconditionForest = WFC2DPreconditionForest.new()

    res.rect = parameters.problem_settings.rect

    var mapper := parameters.problem_settings.rules.mapper

    assert(classes_map != null and not classes_map.is_empty())

    var map_node := parameters.generator_node.get_node(classes_map)
    res.learn_classes_from_map(mapper, map_node)

    assert(seed > 0 or seed == -1)
    if seed == -1:
        randomize()
        res.seed = randi()
    else:
        res.seed = seed

    assert(dirt_threshold > 0)
    res.dirt_threshold = dirt_threshold

    assert(water_threshold > dirt_threshold)
    res.water_threshold = water_threshold

    return res

