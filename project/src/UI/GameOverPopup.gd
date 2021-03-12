extends Popup

func prepare(hero:HeroPawn):
	$PanelContainer/VBoxContainer/ScoreLabel.text = "Score: %d" % (hero.xp + hero.gold)


func _on_PlayAgainButton_pressed():
	get_tree().change_scene("res://src/Game.tscn")
