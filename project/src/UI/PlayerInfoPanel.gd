extends Control

onready var _hp_label := $VBoxContainer/HPLabel
onready var _weapon_label := $VBoxContainer/WeaponLabel
onready var _armor_label := $VBoxContainer/ArmorLabel
onready var _ac_label := $VBoxContainer/ACLabel
onready var _xp_label := $VBoxContainer/XPLabel
onready var _gold_label := $VBoxContainer/GoldLabel
onready var _str_label := $VBoxContainer/StrLabel
onready var _dex_label := $VBoxContainer/DexLabel
onready var _con_label := $VBoxContainer/ConLabel


func init(hero:HeroPawn)->void:
	for attribute in ["equipment", "hp", "gold", "xp", "ac"]:
		var signal_name = "%s_changed" % attribute
		var method_name = "_on_%s" % signal_name
		hero.connect(signal_name, self, method_name, [hero])
		call(method_name, hero)
		
	for attribute in ["strength", "dexterity", "constitution"]:
		var method_name = "_on_%s_changed" % attribute
		hero.get(attribute).connect("changed", self, method_name, [hero])
		call(method_name, hero)
	
	

func _on_equipment_changed(hero:HeroPawn)->void:
	_weapon_label.text = "Weapon: %s (%s)" % [ hero.equipped_weapon.name, hero.equipped_weapon.damage]
	_armor_label.text = "Armor: %s (+%s)" % [ hero.equipped_armor.name, hero.equipped_armor.ac_bonus]


func _on_ac_changed(hero:HeroPawn)->void:
	_ac_label.text = "AC: %d" % hero.ac


func _on_hp_changed(hero:HeroPawn):
	_hp_label.text = "HP: %d/%d" % [hero.hp, hero.max_hp]
	if hero.temp_hp > 0:
		_hp_label.text += " (%d)" % hero.temp_hp


func _on_gold_changed(hero:HeroPawn)->void:
	_gold_label.text = "Gold: %d" % hero.gold


func _format(value:int)->String:
	return ("+%d" % value ) if value > 0 else str(value)


func _on_xp_changed(player):
	_xp_label.text = "XP: %d" % player.xp


func _on_strength_changed(hero:HeroPawn):
	_str_label.text = "Strength: %s" % _format(hero.strength.base_value)
	if hero.strength.modifier!=0:
		_str_label.text += "(%s)" % _format(hero.strength.modifier)


func _on_dexterity_changed(hero:HeroPawn):
	_dex_label.text = "Dexterity: %s" % _format(hero.dexterity.base_value)
	if hero.dexterity.modifier!=0:
		_dex_label.text += "(%s)" % _format(hero.dexterity.modifier)
		
		
func _on_constitution_changed(hero:HeroPawn):
	_con_label.text = "Constitution: %s" % _format(hero.constitution.base_value)
	if hero.constitution.modifier!=0:
		_con_label.text += "(%s)" % _format(hero.constitution.modifier)
