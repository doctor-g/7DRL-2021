extends Node

signal log_changed(message)

# Queue of messages (most recent at end)
var messages = []

func log(message:String):
	assert(message != null)
	assert(message.length() > 0)
	messages.append(message)
	emit_signal("log_changed", message)
