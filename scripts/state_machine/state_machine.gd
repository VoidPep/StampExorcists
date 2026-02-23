extends Node
class_name StateMachine

@export var initial_state : State
var current_state : State
var states : Dictionary = {}

func _ready() -> void:
	var player = $"../.."
	
	for child in get_children():
		if child is State:
			child.setup(player)
			states[child.name.to_lower()] = child
			child.request_transition.connect(_on_request_transition)
			
	if initial_state:
		current_state = initial_state
		current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
	
func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)

	
func _on_request_transition(new_state_name: String) -> void:
	if not current_state:
		return
		
	if not current_state.can_exit():
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		return
		
	if not new_state.can_enter():
		return
		
	current_state.exit()
	current_state = new_state
	current_state.enter()
