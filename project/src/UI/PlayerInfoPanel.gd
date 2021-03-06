extends Control

onready var _hp_label := $VBoxContainer/HPLabel
onready var _weapon_label := $VBoxContainer/WeaponLabel


func init(player):
	on_Player_hp_changed(player)
	on_Player_weapon_changed(player)
	

func on_Player_hp_changed(player):
	_hp_label.text = "HP: %d/%d" % [player.hp, player.max_hp]


func on_Player_weapon_changed(player):
	_weapon_label.text = "Weapon: %s" % player.weapon.get_name()
