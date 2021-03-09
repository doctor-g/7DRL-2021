extends Popup

func prepare(hero:HeroPawn):
	$PanelContainer/VBoxContainer/XPLabel.text = "XP: %d" % hero.xp


func _on_PlayAgainButton_pressed():
	get_tree().change_scene("res://src/Game.tscn")
