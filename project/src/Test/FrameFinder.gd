extends Control

const WIDTH := 48

func _on_TextureRect_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var texture_position : Vector2 = event.position
		var cell := texture_position / 32
		var frame = floor(cell.y) * WIDTH + floor(cell.x)
		$FrameLabel.text = "Frame: %d" % frame
		$FrameSprite.frame = frame
