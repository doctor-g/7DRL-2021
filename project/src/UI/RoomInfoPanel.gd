extends Control

onready var _monsters_label := $MonstersLabel
onready var _items_label := $ItemsLabel
onready var _name_label := $NameLabel
onready var _threat_label := $ThreatLabel

func bind_to(dungeon):
	_name_label.text = dungeon.room_name
	dungeon.connect("changed", self, "_on_Dungeon_changed", [dungeon])
	_on_Dungeon_changed(dungeon) # Update based on initial room.
	


func _on_Dungeon_changed(dungeon):
	_name_label.text = dungeon.room_name
	_monsters_label.text = "Monsters: %d" % dungeon.count_unused_monster_slots()
	_items_label.text = "Items: %d" % dungeon.count_unused_item_slots()
	_threat_label.text = "Threat: %d" % dungeon.get_total_monster_levels()
