extends Control

onready var _hp_label := $VBoxContainer/HPLabel

func on_Player_hp_changed(player):
	_hp_label.text = "HP: %d/%d" % [player.hp, player.max_hp]
	
	
func init(player):
	_hp_label.text = "HP: %d/%d" % [player.hp, player.max_hp]
