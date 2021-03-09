extends PanelContainer

const _SIGNALS = ["monsters_played_changed", "items_played_changed", "stable_turns_changed"]

onready var _monsters_label := $HBoxContainer/MonstersLabel
onready var _items_label := $HBoxContainer/ItemsLabel
onready var _stable_turns_label := $HBoxContainer/StableTurnsLabel


func bind_to(room):
	$HBoxContainer/NameLabel.text = room.name
	for signal_name in _SIGNALS:
		var method = _construct_method_name(signal_name)
		room.connect(signal_name, self, method, [room])
		call(method, room)


func unbind_from(room):
	for signal_name in _SIGNALS:
		room.disconnect(signal_name, self, _construct_method_name(signal_name))
		

func _construct_method_name(signal_name:String)->String:
	return "_on_" + signal_name
	

func _on_monsters_played_changed(room):
	_monsters_label.text = "Monsters Played: %d/%d" % [room.monsters_played, room.max_monsters]


func _on_items_played_changed(room):
	_items_label.text = "Items Played: %d/%d" % [room.items_played,room.max_items]


func _on_stable_turns_changed(room):
	if room.stable_turns > 0:
		_stable_turns_label.text = "Stable Turns: %d" % room.stable_turns
	else:
		_stable_turns_label.text = "Unstable! %s damage/round" % room.damage
