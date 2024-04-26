#AUTEUR : Marc-Olivier Beaulieu
#PROJET : Provider
#NOM DU FICHIER : backpack_inventory.gd
#DESCRIPTION : Logique de la gestion d'items dans l'inventaire du joueur.

extends CanvasLayer

class Item:
	var id:int
	var name:String
	var max_stack:int

	func _init(_id:int, _name:String, _max_stack:int):
		self.id = _id
		self.name = _name
		self.max_stack = _max_stack


class List_Item:
	var collected:int
	var goal:int
	var label:Label

	func _init(_goal:int, _label:Label):
		self.collected = 0
		self.goal = _goal
		self.label = _label

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
# Inventaire plein (Pour tests)
#var inventory = [2,2,2,2 ,2,2,2,2, 2,2,2,2, 2,2,2,2 ,2,2,2,2 ,2,2,2,2 ,2,2,2,2 ,2,2,2,2, 2,2,2,2, 2,2,2,2 ,2,2,2,2 ,2,2,2,2 ,2,2,2,2 ,2,2,2,2, 2,2,2,2, 2,2,2,2]

#Inventaire partiellement plein (Pour tests)
#var inventory = [0,0,0,0,0,1,1,1,1,2,2,2]

#Inventaire vide
var inventory = []

#Liste des ressources à collecter pour la jounée
var list_items = []
@onready var resource_list_labels = [$ResourceList/HBoxContainer/Label,
										$ResourceList/HBoxContainer2/Label,
										$ResourceList/HBoxContainer3/Label]

#Initialisation.
func _ready():
	Globals.berry_picked.connect(on_berry_picked)
	Globals.herbs_picked.connect(on_herbs_picked)
	Globals.wood_picked.connect(on_wood_picked)
	Globals.resistor_picked.connect(on_resistor_picked)
	Globals.remove_item.connect(remove_from_inventory)
	Globals.cashout.connect(cashout)
	Globals.day_end.connect(generate_new_list)
	update_inventory()
	generate_new_list()

func on_berry_picked(amount:int):
	Globals.item_placed.emit(0, add_to_inventory(0,amount))

func on_herbs_picked(amount:int):
	Globals.item_placed.emit(1, add_to_inventory(1,amount))

func on_wood_picked(amount:int):
	Globals.item_placed.emit(2, add_to_inventory(2,amount))

func on_resistor_picked(amount:int):
	Globals.resistors_acquired = true
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
	var inv_copy = inventory
	inventory = []
	inv_copy.sort()
	for i in inv_copy.size():
		place_in_inventory(inv_copy[i])

#Apparition de l'inventaire et du manuel en fonction des actions du joueur
func _unhandled_key_input(event):
	if event.is_action_pressed("inventory"):
		Globals.player_speed = 0 # On arrête le mouvement du joueur.
		if self.visible == true:
			$AnimationPlayer.play("inventory_disappear")
			Globals.player_speed = 500 #On remet le mouvement du joueur.
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
func remove_from_inventory(item_id:int, status:Array):	
	var removed = false
	for i in $Slots.get_child_count(false) - 1:
		var inventory_slot = $Slots.get_child(i, false)
		if inventory_slot.object_id == item_id and !removed:
			inventory_slot.texture = inventory_slot.texture if inventory_slot.object_value > 1 else null
			inventory_slot.object_id = item_id if inventory_slot.object_value > 1 else -1
			inventory_slot.object_value = inventory_slot.object_value - 1 if inventory_slot.object_value > 0 else inventory_slot.object_value
			update_stack_label(inventory_slot)
			inventory.erase(item_id)
			status[0] = true
			removed = true
		elif removed:
			return removed
	return removed

#Met à jour le texte qui indique le nombre d'items dans l'emplacement
func update_stack_label(inventory_slot:Node):
	var label = inventory_slot.get_child(1,false)
	label.text = str(inventory_slot.object_value) if inventory_slot.object_value > 1 else "" 

#Formattage de la string pour le texte de la liste de ressources à collecter.
func format_list_label_text(collected:int, goal:int) -> String:
	var s:String = ""
	if collected < 10:
		s += " " + str(collected)
	else:
		s += str(collected)
	s += " / " 
	if goal < 10:
		s += " " + str(goal)
	else:
		s += str(goal)
	return s

#Génère une nouvelle liste de ressources à collecter
func generate_new_list():
	var rng = RandomNumberGenerator.new()
	list_items = []
	for i in 3:
		list_items.append(List_Item.new((rng.randi() % 24) + 1, resource_list_labels[i]))
		list_items[i].label.text = format_list_label_text(list_items[i].collected, list_items[i].goal)
	await get_tree().create_timer(0.5).timeout
	Globals.quota_complete = false

#Donnes les ressources ramassées à l'hôtesse de l'air et complète la liste
func cashout():
	for item_id in 3:	
		var i:int = 0
		while i < $Slots.get_child_count(false) - 1 and list_items[item_id].collected < list_items[item_id].goal:
			var inventory_slot = $Slots.get_child(i, false)
			if inventory_slot.object_id == item_id:
				inventory_slot.texture = inventory_slot.texture if inventory_slot.object_value > 1 else null
				inventory_slot.object_id = item_id if inventory_slot.object_value > 1 else -1
				inventory_slot.object_value = inventory_slot.object_value - 1 if inventory_slot.object_value > 0 else inventory_slot.object_value
				update_stack_label(inventory_slot)
				inventory.erase(item_id)
				list_items[item_id].collected += 1
				i = 0
			else:
				i += 1
		list_items[item_id].label.text = format_list_label_text(list_items[item_id].collected, list_items[item_id].goal)
	if list_items[0].collected == list_items[0].goal and list_items[1].collected == list_items[1].goal and list_items[2].collected == list_items[2].goal:
		Globals.quota_complete = true
	update_inventory()
