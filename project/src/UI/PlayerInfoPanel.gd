extends Control

onready var _hp_label := $VBoxContainer/HPLabel
onready var _weapon_label := $VBoxContainer/WeaponLabel
onready var _armor_label := $VBoxContainer/ArmorLabel
onready var _gold_label := $VBoxContainer/GoldLabel
onready var _ac_label := $VBoxContainer/ACLabel

func init(player):
	# Set up connections
	for property in ["hp","weapon","armor","gold","ac"]:
		var signal_name = property + "_changed"
		var handler = "_on_Player_" + signal_name
		player.connect(signal_name, self, handler, [player])
		call(handler, player)


func _on_Player_hp_changed(player):
	_hp_label.text = "HP: %d/%d" % [player.hp, player.max_hp]


func _on_Player_weapon_changed(player):
	_weapon_label.text = "Weapon: %s" % player.weapon.get_name()


func _on_Player_gold_changed(player):
	_gold_label.text = "Gold: %d" % player.gold


func _on_Player_ac_changed(player):
	_ac_label.text = "AC: %d" % player.ac


func _on_Player_armor_changed(player):
	_armor_label.text = "Armor: %s" % player.armor.get_name()
