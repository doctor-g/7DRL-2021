class_name Game
extends Node2D

const _Tunnel := preload("res://src/Rooms/Tunnel.gd")

var ap := 0
var player := preload("res://src/Player.gd").new()
var room setget _set_room

var _deck = []
var _discard = []

onready var _Card := load("res://src/Card.tscn")

func _ready():
	# Initialize UI
	_update_ap_label()
	$PlayerInfoPanel.init(player)
	_set_room(_Tunnel.new())
	
	# Load the cards
	var test = ["Armor", "Room", "Gold", "Monster", "Weapon", "Weapon", "Monster", "Weapon",
	 "Weapon", "Monster"]
	for script in test:
		var card = _Card.instance()
		card.command = load("res://src/Cards/%sCard.gd" % script).new()
		_deck.append(card)
	_draw_hand()


func count_monsters() -> int:
	return $MonsterSlot.get_child_count()


func count_items() -> int:
	return $ItemSlot.get_child_count()


func _set_room(new_room)->void:
	if room!=null:
		$RoomInfoPanel.unbind_from(room)
		new_room.monsters_played = room.monsters_played
		new_room.items_played = room.items_played
	room = new_room
	$RoomInfoPanel.bind_to(room)	
	_update_cards()


func _draw_hand():
	for _i in range(0,5):
		if _deck.size() == 0:
			_deck = _discard.duplicate()
			_discard = []
		var card = _deck.pop_front()
		card.connect("played", self, "_on_Card_played", [card], CONNECT_ONESHOT)
		add_card(card)
	_update_cards()


func _on_Card_played(card) -> void:
	card.play(self)
	$CardBox.remove_child(card)
	_discard.append(card)


func add_card(card)->void:
	$CardBox.add_child(card)


func add_monster(monster)->void:
	assert(room.monsters_played < room.max_monsters)
	$MonsterSlot.add_child(monster)
	monster.connect("defeated", self, "_on_Monster_defeated", [monster], CONNECT_ONESHOT)
	room.monsters_played += 1
	_update_cards()
	
	
func _on_Monster_defeated(monster)->void:
	$MonsterSlot.remove_child(monster)
	monster.queue_free()


func _update_cards():
	for card in $CardBox.get_children():
		card.update_playability(self)

	
func add_item(item)->void:
	assert(room.items_played < room.max_items)
	$ItemSlot.add_child(item)
	room.items_played += 1
	_update_cards()


func _on_CardsDoneButton_pressed():
	for child in $CardBox.get_children():
		ap += 1
		_update_ap_label()
		child.disconnect("played", self, "_on_Card_played")
		$CardBox.remove_child(child)
		_discard.append(child)
	$CardsDoneButton.disabled = true
	$ActionsDoneButton.disabled = false
	
	# Listen for interactions
	for monster in $MonsterSlot.get_children():
		monster.connect("pressed", self, "_on_Monster_attacked", [monster])
	for item in $ItemSlot.get_children():
		item.connect("pressed", self, "_on_Item_looted", [item])
	$DoorSlot.get_child(0).connect("pressed", self, "_on_Door_pressed")
	
	
func has_monster():
	return $MonsterSlot.get_child_count() > 0


func _update_ap_label() -> void:
	$HBoxContainer/APLabel.text = "AP: %d" % ap


func _on_ActionsDoneButton_pressed():
	if has_monster():
		_do_all_monster_attack()
	_finish_action_phase()


func _finish_action_phase()->void:
	# Disconnect signals
	for monster in $MonsterSlot.get_children():
		monster.disconnect("pressed", self, "_on_Monster_attacked")
	for item in $ItemSlot.get_children():
		item.disconnect("pressed", self, "_on_Item_looted")
	$DoorSlot.get_child(0).disconnect("pressed", self, "_on_Door_pressed")
	
	# Clean up the phase
	ap = 0
	_update_ap_label()
	$CardsDoneButton.disabled = false
	$ActionsDoneButton.disabled = true
	_draw_hand()	


func has_loot() -> bool:
	return $ItemSlot.get_child_count() > 0


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
		ap -= 1
		_update_ap_label()


func _on_Item_looted(item)->void:
	if ap > 0:
		item.pickup(player)
		item.get_parent().remove_child(item)
		ap -= 1
		
		item.disconnect("pressed", self, "_on_Item_looted")
		
		_do_all_monster_attack()
		
		_update_ap_label()


func _on_Door_pressed():
	if has_monster():
		_do_all_monster_attack()
		ap -= 1
		_update_ap_label()
	else:
		for item in $ItemSlot.get_children():
			$ItemSlot.remove_child(item)
			item.disconnect("pressed", self, "_on_Item_looted")
		_set_room(_Tunnel.new())
		_finish_action_phase()


func _do_all_monster_attack():
	for monster in $MonsterSlot.get_children():
		var roll := Dice.roll("d20")
		var message := "You are attacked by the %s (%d). " % [monster.name, roll]
		if roll >= player.ac:
			var damage = Dice.roll(monster.damage)
			print(message + "It hits for %d!" % damage)
			player.hp -= damage
		else:
			print(message + "It misses!")
