extends Node
class_name StateMachine

@export var initial_state : State
var current_state : State
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			print_debug(child.name.to_lower())
			
			child.state_changer.connect(on_state_changed)
			
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
	
func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)

func on_state_changed(state: State, new_state_name: String) -> void:
	if state != current_state:
		return
		
	var new_state =  states.get(new_state_name.to_lower())
	if not current_state:
		return
		
	current_state.exit()	
	current_state = new_state
	current_state.enter()
	
