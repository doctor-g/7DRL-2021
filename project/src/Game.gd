class_name Game
extends Node2D

signal ap_changed
signal phase_changed

const _Tunnel := preload("res://src/Rooms/Tunnel.gd")
const PHASES = [ "Build", "Adventure" ]
const BUILD_PHASE = PHASES[0]
const ADVENTURE_PHASE = PHASES[1]

var ap := 0 setget _set_ap
var player := preload("res://src/Player.gd").new()
var room setget _set_room

var _phase : String = PHASES[0] setget _set_phase
var _deck = []
var _discard = []

onready var _Card := load("res://src/Card.tscn")

func _ready():
	# Initialize player
	player.connect("hp_changed", self, "_on_Player_hp_changed")
	
	# Initialize UI
	$PlayerInfoPanel.init(player)
	$PhasePanel.bind_to(self)
	$ShopPanel.bind_to(self)
	_set_room(_Tunnel.new())
	
	# Load the cards
	var test = [ "Armor", "Room", "Gold", "Monster", "Weapon",
				 "Armor", "Room", "Gold", "Monster", "Weapon" ]
	for script in test:
		var card = _Card.instance()
		card.set_script(load("res://src/Cards/%sCard.gd" % script))
		_deck.append(card)
	
	_deck.shuffle()
	_draw_hand()


func _on_Player_hp_changed()->void:
	if player.hp <= 0:
		$GameOverPopup.show_modal(true)


func count_monsters() -> int:
	return _count_occupied_slots($Monsters)


func _count_occupied_slots(node:Node2D):
	var result := 0
	for child in node.get_children():
		if child.get_child_count() > 0:
			result += 1
	return result


# Get the sum of all monster levels in the current room
func get_total_monster_levels() ->int:
	var sum := 0
	for monster in get_monsters():
		sum += monster.level
	return sum


func get_monsters()->Array:
	return _get_slotted_things($Monsters)
	

func get_items()->Array:
	return _get_slotted_things($Items)


func _get_slotted_things(node:Node2D)->Array:
	var array = []
	for child in node.get_children():
		if child.get_child_count() == 1:
			array.append(child.get_child(0))
	return array


func count_items() -> int:
	return _count_occupied_slots($Items)


func _set_room(new_room)->void:
	if room!=null:
		$RoomInfoPanel.unbind_from(room)
	room = new_room
	$RoomInfoPanel.bind_to(room)	
	_update_cards()


func _draw_hand():
	for _i in range(0,5):
		if _deck.size() == 0:
			_deck = _discard.duplicate()
			_deck.shuffle()
			_discard = []
		var card = _deck.pop_front()
		card.connect("played", self, "_on_Card_played", [card], CONNECT_ONESHOT)
		$CardPanel.add(card)
	_update_cards()


func _on_Card_played(card) -> void:
	card.play(self)
	$CardPanel.remove(card)
	add_to_discard(card)
	

func add_to_discard(card):
	_discard.append(card)


func add_monster(monster)->void:
	assert(room.monsters_played < room.max_monsters)
	_add_to_next_available_slot($Monsters, monster)
	monster.connect("defeated", self, "_on_Monster_defeated", [monster], CONNECT_ONESHOT)
	room.monsters_played += 1
	_update_cards()


func _add_to_next_available_slot(parent:Node2D, thing:Node)->void:
	for child in parent.get_children():
		if child.get_child_count() == 0:
			child.add_child(thing)
			return
	assert("Out of slots!")
		
	
func _on_Monster_defeated(monster)->void:
	monster.queue_free()


func _update_cards():
	for card in $CardPanel.get_cards():
		card.update_playability(self)

	
func add_item(item)->void:
	assert(room.items_played < room.max_items)
	_add_to_next_available_slot($Items, item)
	room.items_played += 1
	_update_cards()


func _on_CardsDoneButton_pressed():
	for child in $CardPanel.get_cards():
		_set_ap(ap + 1)
		child.disconnect("played", self, "_on_Card_played")
		$CardPanel.remove(child)
		_discard.append(child)
	$CardsDoneButton.disabled = true
	
	# Listen for interactions
	for monster in get_monsters():
		monster.connect("pressed", self, "_on_Monster_attacked", [monster])
	for item in get_items():
		item.connect("pressed", self, "_on_Item_looted", [item])
	$DoorSlot.get_child(0).connect("pressed", self, "_on_Door_pressed")
	
	$ShopPanel.visible = true
	_set_phase(ADVENTURE_PHASE)
	
	
func has_monster():
	return count_monsters() > 0


func _on_PhasePanel_done_pressed():
	if has_monster():
		_do_all_monster_attack()
	_finish_action_phase()


func _finish_action_phase()->void:
	# Disconnect signals
	for monster in get_monsters():
		monster.disconnect("pressed", self, "_on_Monster_attacked")
	for item in get_items():
		item.disconnect("pressed", self, "_on_Item_looted")
	$DoorSlot.get_child(0).disconnect("pressed", self, "_on_Door_pressed")
	
	# Clean up the phase
	_set_ap(0)
	$CardsDoneButton.disabled = false
	$ShopPanel.visible = false
	_draw_hand()
	_set_phase(BUILD_PHASE)


func _on_Monster_attacked(monster)->void:
	if ap > 0:
		var roll := Dice.roll("d20")
		var message := "You attack the %s (%d). " % [monster.name, roll]
		if roll >= monster.ac:
			var damage : int = player.weapon.compute_damage()
			monster.hp -= damage
			print("%sYou hit for %d damage!" % [message, damage])
		else:
			print(message + "You missed.")
		_set_ap(ap-1)


func _on_Item_looted(item)->void:
	if ap > 0:
		item.pickup(player)
		item.get_parent().remove_child(item)
		_set_ap(ap-1)
		item.disconnect("pressed", self, "_on_Item_looted")
		_do_all_monster_attack()


func _on_Door_pressed():
	if ap == 0:
		return
	if has_monster():
		_do_all_monster_attack()
		_set_ap(ap-1)
	else:
		for item in get_items():
			item.disconnect("pressed", self, "_on_Item_looted")
			item.queue_free()			
		_set_room(_Tunnel.new())
		_finish_action_phase()


func _do_all_monster_attack():
	for monster in get_monsters(): 
		var roll := Dice.roll("d20")
		var message := "You are attacked by the %s (%d). " % [monster.name, roll]
		if roll >= player.ac:
			var damage = Dice.roll(monster.damage)
			print(message + "It hits for %d!" % damage)
			player.hp -= damage
		else:
			print(message + "It misses!")


func _set_ap(value):
	ap = value
	emit_signal("ap_changed", ap)


func _set_phase(value):
	assert(PHASES.has(value))
	_phase = value
	emit_signal("phase_changed", _phase)
