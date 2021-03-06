class_name Game 
extends Node2D

var ap := 0
var player := preload("res://src/Player.gd").new()

var _deck = []
var _discard = []

onready var _Card := load("res://src/Card.tscn")

func _ready():
	# Initialize UI
	_update_ap_label()
	_update_hp_label()
	player.connect("hp_changed", self, "_update_hp_label")
	
	# Load the cards
	var test = ["Goblin.gd", "Weapon.gd", "Weapon.gd", "Goblin.gd", "Weapon.gd",
	 "Weapon.gd", "Goblin.gd", "Weapon.gd", "Weapon.gd", "Goblin.gd"]
	for script in test:
		var card = _Card.instance()
		card.command = load("res://src/Cards/%s" % script).new()
		_deck.append(card)
	_draw_hand()


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


func _update_action_buttons():
	$HBoxContainer/AttackButton.disabled = not has_monster() or ap==0
	$HBoxContainer/LootButton.disabled = not has_loot() or has_monster() or ap==0
	$HBoxContainer/RestButton.disabled = has_monster() or ap==0 or player.hp == 10
	$ActionsDoneButton.disabled = false
	
	
func has_monster():
	return $MonsterSlot.get_child_count() > 0


func _update_ap_label() -> void:
	$HBoxContainer/APLabel.text = "AP: %d" % ap


func _on_ActionsDoneButton_pressed():
	ap = 0
	_update_ap_label()
	$HBoxContainer/AttackButton.disabled = true
	$HBoxContainer/LootButton.disabled = true
	$HBoxContainer/RestButton.disabled = true
	$CardsDoneButton.disabled = false
	$ActionsDoneButton.disabled = true
	
	if has_monster():
		print("The goblin strikes you!")
		player.hp -= 2
	
	_draw_hand()


func _on_AttackButton_pressed():
	assert(has_monster(), "There is no monster to attack")
	assert(ap > 0)
	var monster = $MonsterSlot.get_child(0)
	print("You strike it!")
	monster.hp -= 1
	ap -= 1
	_update_ap_label()
	_update_action_buttons()


func _on_LootButton_pressed():
	assert(has_loot(), "There is no loot")
	print("You got loot")
	$ItemSlot.remove_child($ItemSlot.get_child(0))
	_update_action_buttons()
	ap -= 1
	_update_ap_label()


func has_loot() -> bool:
	return $ItemSlot.get_child_count() > 0


func _on_RestButton_pressed():
	assert(player.hp < 10)
	player.hp += 1
	ap -= 1
	_update_ap_label()
