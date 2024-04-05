extends CanvasLayer

class Item:
	var id:int
	var name:String
	var max_stack:int

	func _init(_id:int, _name:String, _max_stack:int):
		self.id = _id
		self.name = _name
		self.max_stack = _max_stack

#Dictionnaire des noms des items avec leur ID.
var items = [
	Item.new(0, "berry", 8),
	Item.new(1,"herb", 8),
	Item.new(2,"wood", 4),
	Item.new(3, "resistor", 1)]

#Liste des textures d'items en ordre d'ID
var textures:Array = [
					load("res://graphics/Backpack/Green/Categories/1 - Inventory/Sprites/items/10.png"),
					load("res://graphics/Backpack/Green/Categories/1 - Inventory/Sprites/items/7.png"),
					load("res://graphics/Backpack/Green/Categories/1 - Inventory/Sprites/items/9.png"),
					load("res://graphics/objects/electrical/resistor_item.png")
					]

#Liste des items présents dans l'inventaire du joueur
var inventory = []

##Liste des items présents dans l'inventaire du joueur
#var inventory = [2,2,1,1,1,1,0,2,2,2,2,3,3,3]

#Initialisation.
func _ready():
	Globals.berry_picked.connect(on_berry_picked)
	Globals.herbs_picked.connect(on_herbs_picked)
	Globals.wood_picked.connect(on_wood_picked)
	Globals.resistor_picked.connect(on_resistor_picked)
	Globals.remove_item.connect(remove_from_inventory)
	update_inventory()

func on_berry_picked(amount:int):
	Globals.item_placed.emit(0, add_to_inventory(0,amount))

func on_herbs_picked(amount:int):
	Globals.item_placed.emit(1, add_to_inventory(1,amount))

func on_wood_picked(amount:int):
	Globals.item_placed.emit(2, add_to_inventory(2,amount))

func on_resistor_picked(amount:int):
	Globals.item_placed.emit(3, add_to_inventory(3,amount))

#Enlève tous les tiems du sac à dos et les remet selon ce qui est présent dans inventory.
func update_inventory():
	for i in $Slots.get_child_count(false) - 1:
		var inventory_slot = $Slots.get_child(i, false)
		if inventory_slot.object_id != -1:
			inventory_slot.texture = null
			inventory_slot.object_id = -1
			inventory_slot.object_value = -1
			update_stack_label(inventory_slot)
		
	inventory.sort()
	for i in inventory.size():
		place_in_inventory(inventory[i])

#Apparition de l'inventaire et du manuel en fonction des actions du joueur
func _unhandled_key_input(event):
	if event.is_action_pressed("inventory"):
		Globals.player_can_move = false # On arrête le mouvement du joueur.
		if self.visible == true:
			$AnimationPlayer.play("inventory_disappear")
			Globals.player_can_move = true # On remet le mouvement du joueur.			
		else:
			$AnimationPlayer.play("inventory_appear")
	elif event.is_action_pressed("journal") and self.visible == true:
		if $Manual.visible == true:
			$AnimationPlayer.play("manual_disappear")
		else:
			$AnimationPlayer.play("manual_appear")

func _on_animation_player_animation_finished(_anim_name:StringName):
	pass

#Ajoute un item dans l'inventaire
func add_to_inventory(item_id:int, amount:int):
	var status:bool = false
	for i in amount:
		status = place_in_inventory(item_id)
	return status

#Place un item dans le premier endroit valide dans l'inventaire
func place_in_inventory(item_id:int):
	var placed = false
	for i in $Slots.get_child_count(false) - 1:
		var inventory_slot = $Slots.get_child(i, false)
		if inventory_slot.object_id == item_id and !placed and inventory_slot.object_value < items[item_id].max_stack:
			inventory_slot.object_value += 1
			update_stack_label(inventory_slot)
			inventory.append(item_id)
			placed = true
		elif inventory_slot.texture == null and !placed:
			inventory_slot.texture = textures[item_id]
			inventory_slot.object_id = item_id
			inventory_slot.object_value += 1
			update_stack_label(inventory_slot)
			inventory.append(item_id)
			placed = true
		elif placed:
			return placed
	return placed

#Enlève un item de l'inventaire
func remove_from_inventory(item_id:int):	
	var removed = false
	for i in $Slots.get_child_count(false) - 1:
		var inventory_slot = $Slots.get_child(i, false)
		if inventory_slot.object_id == item_id and !removed:
			inventory_slot.texture = inventory_slot.texture if inventory_slot.object_value > 0 else null
			inventory_slot.object_id = -1
			inventory_slot.object_value = inventory_slot.object_value - 1 if inventory_slot.object_value > 0 else inventory_slot.object_value
			update_stack_label(inventory_slot)
			inventory.erase(item_id)
			removed = true
		elif removed:
			return removed
	return removed

#Met à jour le texte qui indique le nombre d'items dans l'emplacement
func update_stack_label(inventory_slot:Node):
	var label = inventory_slot.get_child(1,false)
	label.text = str(inventory_slot.object_value) if inventory_slot.object_value > 1 else "" 
