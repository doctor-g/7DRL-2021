extends Node

signal log_changed(message)

# History of messages (most recent at end)
var messages = []

var _queue = []

# Queue a message for logging
func queue(message:String):
	_queue.append(message)
	
	
# Flush the queue to the log
func flush():
	if not _queue.empty():
		var message := ""
		for partial in _queue:
			message += partial + " "
		call("log", message)
		_queue.clear()
		
	

func log(message:String):
	assert(message != null)
	assert(message.length() > 0)
	messages.append(message)
	emit_signal("log_changed", message)
