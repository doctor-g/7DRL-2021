extends Control

onready var _hp_label := $VBoxContainer/HPLabel
onready var _weapon_label := $VBoxContainer/WeaponLabel
onready var _gold_label := $VBoxContainer/GoldLabel

func init(player):
	# Set up connections
	player.connect("hp_changed", self, "_on_Player_hp_changed", [player])
	player.connect("weapon_changed", self, "_on_Player_weapon_changed", [player])
	player.connect("gold_changed", self, "_on_Player_gold_changed", [player])
	
	# Trigger the handlers to force them to show the initial stats
	_on_Player_hp_changed(player)
	_on_Player_weapon_changed(player)
	_on_Player_gold_changed(player)
	

func _on_Player_hp_changed(player):
	_hp_label.text = "HP: %d/%d" % [player.hp, player.max_hp]


func _on_Player_weapon_changed(player):
	_weapon_label.text = "Weapon: %s" % player.weapon.get_name()


func _on_Player_gold_changed(player):
	_gold_label.text = "Gold: %d" % player.gold
