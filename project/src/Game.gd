class_name Game
extends Node2D

const _Tunnel := preload("res://src/Rooms/Tunnel.gd")

var ap := 0
var player := preload("res://src/Player.gd").new()
var room = _Tunnel.new() setget _set_room

var _deck = []
var _discard = []

onready var _Card := load("res://src/Card.tscn")

func _ready():
	# Initialize UI
	_update_ap_label()
	_update_room_label()
	player.connect("hp_changed", $PlayerInfoPanel, "on_Player_hp_changed", [player])
	player.connect("weapon_changed", $PlayerInfoPanel, "on_Player_weapon_changed", [player])
	$PlayerInfoPanel.init(player)
	
	# Load the cards
	var test = ["SmallChamber.gd", "Goblin.gd", "Weapon.gd", "Weapon.gd", "Goblin.gd", "Weapon.gd",
	 "Weapon.gd", "Goblin.gd", "Weapon.gd", "Weapon.gd"]
	for script in test:
		var card = _Card.instance()
		card.command = load("res://src/Cards/%s" % script).new()
		_deck.append(card)
	_draw_hand()


func count_monsters() -> int:
	return $MonsterSlot.get_child_count()


func count_items() -> int:
	return $ItemSlot.get_child_count()


func _set_room(value)->void:
	room = value
	_update_room_label()
	_update_cards()


func _update_room_label():
	$RoomNameLabel.text = room.name
	

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
	assert($MonsterSlot.get_child_count()==0, "Can only have one monster")
	$MonsterSlot.add_child(monster)
	monster.connect("defeated", self, "_on_Monster_defeated", [monster], CONNECT_ONESHOT)
	_update_cards()
	
	
func _on_Monster_defeated(monster)->void:
	$MonsterSlot.remove_child(monster)
	monster.queue_free()


func _update_cards():
	for card in $CardBox.get_children():
		card.update_playability(self)

	
func add_item(item)->void:
	assert($ItemSlot.get_child_count()==0, "Can only have one item")
	$ItemSlot.add_child(item)
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
		print("The goblin strikes you!")
		player.hp -= 2
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
		var damage : int = player.weapon.compute_damage()
		monster.hp -= damage
		ap -= 1
		_update_ap_label()


func _on_Item_looted(item)->void:
	if ap > 0:
		item.pickup(player)
		item.queue_free()
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
		print("The %s attacks you!" % monster.name)
		player.hp -= 2
