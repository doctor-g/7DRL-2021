extends Popup

func prepare(player):
	$PanelContainer/VBoxContainer/XPLabel.text = "XP: %d" % player.xp


func _on_PlayAgainButton_pressed():
	get_tree().change_scene("res://src/Game.tscn")
