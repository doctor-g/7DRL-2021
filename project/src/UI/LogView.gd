extends Control

onready var _latest_message_label := $PanelContainer/HBoxContainer/LatestMessageLabel

func _init():
	Log.connect("log_changed", self, "_on_log_changed")


func _on_log_changed(message:String):
	_latest_message_label.text = message


func _on_ExpandButton_toggled(button_pressed):
	$History.text = "" if Log.messages.size()>0 else "No messages..."
	for message in Log.messages:
		$History.text += message + "\n"
	$History.visible = button_pressed
	$PanelContainer/HBoxContainer/ExpandButton.text = "↓" if button_pressed else "↑"
