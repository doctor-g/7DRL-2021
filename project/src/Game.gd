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
	_update_hp_label()
	_update_room_label()
	player.connect("hp_changed", self, "_update_hp_label")
	
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
	

func _update_hp_label() -> void:
	$HPLabel.text = "HP: %d" % player.hp


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
	_update_action_buttons()
	

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
	_update_action_buttons()
	$CardsDoneButton.disabled = true
	
	# Listen for attacking the monsters
	for monster in $MonsterSlot.get_children():
		monster.connect("pressed", self, "_on_Monster_attacked", [monster])
	# Listen for looting the items
	for item in $ItemSlot.get_children():
		item.connect("pressed", self, "_on_Item_looted", [item])
	
	
func _update_action_buttons():
	$HBoxContainer/RestButton.disabled = has_monster() or ap==0 or player.hp == 10
	$HBoxContainer/AdvanceButton.disabled = has_monster() or ap == 0
	$ActionsDoneButton.disabled = false
	
	
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
	for monster in $MonsterSlot.get_children():
		monster.disconnect("pressed", self, "_on_Monster_attacked")
	for item in $ItemSlot.get_children():
		item.disconnect("pressed", self, "_on_Item_looted")
	ap = 0
	_update_ap_label()
	$HBoxContainer/RestButton.disabled = true
	$HBoxContainer/AdvanceButton.disabled = true
	$CardsDoneButton.disabled = false
	$ActionsDoneButton.disabled = true
	_draw_hand()	


func has_loot() -> bool:
	return $ItemSlot.get_child_count() > 0


func _on_RestButton_pressed():
	assert(player.hp < 10)
	player.hp += 1
	ap -= 1
	_update_ap_label()
	_update_action_buttons()


func _on_AdvanceButton_pressed():
	assert(not has_monster())
	for item in $ItemSlot.get_children():
		$ItemSlot.remove_child(item)
		item.disconnect("pressed", self, "_on_Item_looted")
	_set_room(_Tunnel.new())
	_finish_action_phase()



func _on_Monster_attacked(monster)->void:
	if ap > 0:
		monster.hp -= 1
		ap -= 1
		_update_ap_label()
		_update_action_buttons()


func _on_Item_looted(item)->void:
	if ap > 0:
		print("LOOTED")
		item.queue_free()
		ap -= 1
		
		item.disconnect("pressed", self, "_on_Item_looted")
		
		for monster in $MonsterSlot.get_children():
			print("The %s attacks you!" % monster.name)
			player.hp -= 2
		
		_update_ap_label()
		_update_action_buttons()
