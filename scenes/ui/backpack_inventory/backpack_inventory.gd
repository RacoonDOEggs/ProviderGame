extends CanvasLayer

var items = {"fish":0,
			"egg":1,
			"blue_book":2,
			"candy":3,
			"red_book":4,
			"stone":5,
			"cloth":6,
			"leaves":7,
			"gold":8,
			"wood":9}

var textures:Array = [ResourceLoader.load("res://graphics/Backpack/Green/Categories/1 - Inventory/Sprites/items/0.png"),
					ResourceLoader.load("res://graphics/Backpack/Green/Categories/1 - Inventory/Sprites/items/1.png"),
					ResourceLoader.load("res://graphics/Backpack/Green/Categories/1 - Inventory/Sprites/items/2.png"),
					ResourceLoader.load("res://graphics/Backpack/Green/Categories/1 - Inventory/Sprites/items/3.png"),
					ResourceLoader.load("res://graphics/Backpack/Green/Categories/1 - Inventory/Sprites/items/4.png"),
					ResourceLoader.load("res://graphics/Backpack/Green/Categories/1 - Inventory/Sprites/items/5.png"),
					ResourceLoader.load("res://graphics/Backpack/Green/Categories/1 - Inventory/Sprites/items/6.png"),
					ResourceLoader.load("res://graphics/Backpack/Green/Categories/1 - Inventory/Sprites/items/7.png"),
					ResourceLoader.load("res://graphics/Backpack/Green/Categories/1 - Inventory/Sprites/items/8.png"),
					ResourceLoader.load("res://graphics/Backpack/Green/Categories/1 - Inventory/Sprites/items/9.png"),]

var inventory = [2,5,8,4,3]

func _ready():
	$Slots.get_child(1, false).texture = textures[1]
	#for i in inventory.size():
		#print(place_in_inventory(inventory[i]))

func place_in_inventory(item_id:int):
	var placed = false
	for i in $Slots.get_child_count(false):
		var inventory_slot = $Slots.get_child(i, false)
		if inventory_slot.texture == null and !placed:
			inventory_slot.texture = textures[item_id]
			inventory_slot.object_id = item_id
			placed = true
		elif placed:
			return placed
	return placed