extends Node
class_name State

signal request_transition(new_state_name: String)

var player: Player

func setup(p: Player):
	player = p

func connect_event(event, cbFunction):
	if not event.is_connected(cbFunction):
		event.connect(cbFunction)

func disconnect_event(event, cbFunction):
	if event.is_connected(cbFunction):
		event.disconnect(cbFunction)

func can_enter() -> bool:
	return true

func can_exit() -> bool:
	return true

func enter():
	pass

func exit():
	pass

func update(delta):
	pass

func physics_update(delta):
	pass
