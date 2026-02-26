extends CanvasLayer
class_name TutorialUI

@onready var panel : PanelContainer = $Panel
@onready var hint_label : Label = $Panel/MarginContainer/HBox/VBoxContainer/HintLabel
@onready var progress_label: Label = $Panel/MarginContainer/HBox/VBoxContainer/ProgressLabel
@onready var key_label : Label = $Panel/MarginContainer/HBox/KeyContainer/KeyLabel
@onready var anim : AnimationPlayer = $AnimationPlayer

func show_hint(text: String, key_icon: String, progress: String = "") -> void:
	hint_label.text    = text
	key_label.text     = key_icon
	progress_label.text = progress

	anim.stop()
	anim.play("slide_in")
	await anim.animation_finished
	anim.play("pulse")

func update_progress(progress: String) -> void:
	progress_label.text = progress


func hide_hint(await_finish: bool = true) -> void:
	anim.stop()
	anim.play("slide_out")
	if await_finish:
		await anim.animation_finished
	panel.modulate = Color(1, 1, 1, 0)


func flash_complete() -> void:
	hint_label.text = "✓ Feito!"
	progress_label.text = ""
	key_label.text = "✓"
	anim.stop()
	
	var tween := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "scale", Vector2(1.08, 1.08), 0.1)
	tween.tween_property(panel, "scale", Vector2(1.0,  1.0),  0.1)
	await tween.finished
	await get_tree().create_timer(0.6).timeout
	await hide_hint()
