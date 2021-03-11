extends Control

const _TEXTURE_CELL_SIZE := 16

var _hero:HeroPawn

onready var _hp_label := $VBoxContainer/HPLabel
onready var _ac_label := $VBoxContainer/ACLabel
onready var _xp_label := $VBoxContainer/XPLabel
onready var _gold_label := $VBoxContainer/GoldLabel
onready var _str_label := $VBoxContainer/StrLabel
onready var _dex_label := $VBoxContainer/DexLabel
onready var _con_label := $VBoxContainer/ConLabel
onready var _weapon_selector := $VBoxContainer/WeaponSelector
onready var _armor_selector := $VBoxContainer/ArmorSelector

func init(hero:HeroPawn)->void:
	_hero = hero
	
	for attribute in ["equipment", "hp", "gold", "xp", "ac"]:
		var signal_name = "%s_changed" % attribute
		var method_name = "_on_%s" % signal_name
		hero.connect(signal_name, self, method_name, [hero])
		call(method_name, hero)
		
	for attribute in ["strength", "dexterity", "constitution"]:
		var method_name = "_on_%s_changed" % attribute
		hero.get(attribute).connect("changed", self, method_name, [hero])
		call(method_name, hero)
	
	_update_weapon_selector()
	_update_armor_selector()
	

func _on_equipment_changed(_the_hero:HeroPawn)->void:
	_update_weapon_selector()
	_update_armor_selector()


func _update_weapon_selector():
	_weapon_selector.clear()
	for weapon in _hero.weapons:
		_weapon_selector.add_icon_item(_texture_from(weapon), weapon.to_string())
	_weapon_selector.selected = _hero.weapons.find(_hero.equipped_weapon)


func _update_armor_selector():
	_armor_selector.clear()
	for armor in _hero.armor:
		_armor_selector.add_icon_item(_texture_from(armor), armor.to_string())
	_armor_selector.selected = _hero.armor.find(_hero.equipped_armor)


func _texture_from(item:ItemActor)->Texture:
	var original_texture : Texture = item.get_node("Sprite").texture
	var result := AtlasTexture.new()
	result.atlas = original_texture
# warning-ignore:integer_division
	var columns := original_texture.get_width() / _TEXTURE_CELL_SIZE
	var x : int = item.frame % columns
# warning-ignore:integer_division
	var y : int = item.frame / columns
	result.region = Rect2(x*16,y*16,16,16)
	return result


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


func _on_WeaponSelector_item_selected(index:int):
	_hero.equip_weapon(_hero.weapons[index])
	Log.queue("You ready your %s." % _hero.equipped_weapon.name)
	_hero.emit_signal("took_turn")


func _on_ArmorSelector_item_selected(index):
	_hero.equip_armor(_hero.armor[index])
	Log.queue("You suit up in your %s." % _hero.equipped_armor.name)
	_hero.emit_signal("took_turn")
