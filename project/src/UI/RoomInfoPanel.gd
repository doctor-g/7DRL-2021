extends PanelContainer

onready var _monsters_label := $HBoxContainer/MonstersLabel
onready var _items_label := $HBoxContainer/ItemsLabel

func bind_to(dungeon):
	$HBoxContainer/NameLabel.text = dungeon.name
	dungeon.connect("changed", self, "_on_Dungeon_changed", [dungeon])
	_on_Dungeon_changed(dungeon) # Update based on initial room.

func _on_Dungeon_changed(dungeon):
	_monsters_label.text = "Monster Slots: %d" % dungeon.count_unused_monster_slots()
	_items_label.text = "Item Slots: %d" % dungeon.count_unused_item_slots()
