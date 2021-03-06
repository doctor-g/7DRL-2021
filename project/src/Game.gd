class_name Game 
extends Node2D

var ap := 0

var _deck = []
var _discard = []

onready var _Card := load("res://src/Card.tscn")

func _ready():
	# Initialize UI
	_update_ap_label()
	
	# Load the cards
	var test = ["Goblin.gd", "Weapon.gd", "Weapon.gd", "Goblin.gd", "Weapon.gd",
	 "Weapon.gd", "Goblin.gd", "Weapon.gd", "Weapon.gd", "Goblin.gd"]
	for script in test:
		var card = _Card.instance()
		card.command = load("res://src/Cards/%s" % script).new()
		_deck.append(card)
	_draw_hand()
	

func _draw_hand():
	for _i in range(0,5):
		if _deck.size() == 0:
			_deck = _discard.duplicate()
			_discard = []
		var card = _deck.pop_front()
		card.connect("played", self, "_on_Card_played", [card], CONNECT_ONESHOT)
		add_card(card)


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
	

func _on_Monster_defeated(monster)->void:
	$MonsterSlot.remove_child(monster)
	monster.queue_free()
	_update_action_buttons()
	
	
func add_item(item)->void:
	assert($ItemSlot.get_child_count()==0, "Can only have one item")
	$ItemSlot.add_child(item)


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
	$HBoxContainer/AttackButton.disabled = not _has_monster() or ap==0
	$HBoxContainer/LootButton.disabled = not _has_loot() or _has_monster() or ap==0
	$HBoxContainer/RestButton.disabled = _has_monster() or ap==0
	$ActionsDoneButton.disabled = false
	
	
func _has_monster():
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
	_draw_hand()


func _on_AttackButton_pressed():
	assert(_has_monster(), "There is no monster to attack")
	$MonsterSlot.get_child(0).defeat()
	ap -= 1
	_update_ap_label()


func _on_LootButton_pressed():
	assert(_has_loot(), "There is no loot")
	print("You got loot")
	$ItemSlot.remove_child($ItemSlot.get_child(0))
	_update_action_buttons()
	ap -= 1
	_update_ap_label()


func _has_loot() -> bool:
	return $ItemSlot.get_child_count() > 0
