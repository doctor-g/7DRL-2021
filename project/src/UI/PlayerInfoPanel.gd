extends Control

onready var _hp_label := $VBoxContainer/HPLabel
onready var _weapon_label := $VBoxContainer/WeaponLabel
onready var _armor_label := $VBoxContainer/ArmorLabel
onready var _ac_label := $VBoxContainer/ACLabel
onready var _xp_label := $VBoxContainer/XPLabel
onready var _gold_label := $VBoxContainer/GoldLabel


func init(hero:HeroPawn)->void:
	for attribute in ["equipment", "hp", "gold", "xp"]:
		var signal_name = "%s_changed" % attribute
		var method_name = "_on_%s" % signal_name
		hero.connect(signal_name, self, method_name, [hero])
		call(method_name, hero)
	

func _on_equipment_changed(hero:HeroPawn)->void:
	_weapon_label.text = "Weapon: %s (%s)" % [ hero.equipped_weapon.name, hero.equipped_weapon.damage]
	_armor_label.text = "Armor: %s (+%s)" % [ hero.equipped_armor.name, hero.equipped_armor.ac_bonus]
	_ac_label.text = "AC: %d" % hero.ac


func _on_hp_changed(hero:HeroPawn):
	_hp_label.text = "HP: %d/%d" % [hero.hp, hero.max_hp]


func _on_gold_changed(hero:HeroPawn)->void:
	_gold_label.text = "Gold: %d" % hero.gold


func _format(value:int)->String:
	return ("+%d" % value ) if value > 0 else str(value)


func _on_xp_changed(player):
	_xp_label.text = "XP: %d" % player.xp
