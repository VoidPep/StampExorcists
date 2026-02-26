extends Node
class_name TutorialManager

@export var player       : Player
@export var tutorial_ui  : TutorialUI

signal tutorial_completed

var steps: Array = [
	{
		"text":  "Mover-se",
		"icon":  "WASD / Analógico esquerdo",
		"count":  3,
		"_counter": 0,
		"check": _check_movement,
	},
	{
		"text":  "Atacar",
		"icon":  "Clique do mouse / A / X",
		"count":  2,
		"_counter": 0,
		"check": _check_attack,
	},
	{
		"text":  "Use o Dash",
		"icon":  "SHIFT / RB / R1",
		"count":  1,
		"_counter": 0,
		"check": _check_dash,
	}
]

var current_step_index := -1
var active := false

var _waiting_next := false
var _movement_cooldown := 0.0

func _ready() -> void:
	player.attacked.connect(_on_player_attacked)

func start_tutorial() -> void:
	active = true
	current_step_index = 0
	_show_step(steps[0])

func _process(delta):
	if not active or _waiting_next:
		return
	if current_step_index >= steps.size():
		return

	if _movement_cooldown > 0:
		_movement_cooldown -= delta

	var step = steps[current_step_index]
	if step["check"].call(step, delta):
		_complete_step()

func _check_movement(step: Dictionary, delta: float = 0.0) -> bool:
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if dir != Vector2.ZERO and _movement_cooldown <= 0.0:
		step["_counter"] += 1
		_movement_cooldown = 0.4
		_update_progress(step)
	return step["_counter"] >= step["count"]


func _check_dash(step: Dictionary, delta) -> bool:
	return step["_counter"] >= step["count"]


func _check_attack(step: Dictionary, delta) -> bool:
	return step["_counter"] >= step["count"]

func _on_player_attacked() -> void:
	if not active or _waiting_next:
		return
	var step = steps[current_step_index]
	if step["check"] == _check_attack:
		step["_counter"] += 1
		_update_progress(step)

func _input(event: InputEvent) -> void:
	if not active or _waiting_next:
		return
	var step = steps[current_step_index]
	if step["check"] == _check_dash and event.is_action_pressed("dash"):
		step["_counter"] += 1

func _complete_step() -> void:
	_waiting_next = true
	await tutorial_ui.flash_complete()
	_next_step()
	_waiting_next = false


func _next_step() -> void:
	current_step_index += 1
	if current_step_index >= steps.size():
		_finish_tutorial()
		return
	_show_step(steps[current_step_index])


func _show_step(step: Dictionary) -> void:
	var progress = _progress_text(step)
	tutorial_ui.show_hint(step["text"], step["icon"], progress)


func _finish_tutorial() -> void:
	active = false
	await tutorial_ui.hide_hint()
	tutorial_completed.emit()

func _update_progress(step: Dictionary) -> void:
	tutorial_ui.update_progress(_progress_text(step))


func _progress_text(step: Dictionary) -> String:
	if step["count"] <= 1:
		return ""
	return "%d / %d" % [mini(step["_counter"], step["count"]), step["count"]]
