extends Control

func _ready():
	$Menu/CenterContainer/VBoxContainer/Start.pressed.connect(_on_start_pressed)
	$Menu/CenterContainer/VBoxContainer/Exit.pressed.connect(_on_exit_pressed)

func _on_start_pressed():
	await create_tween().tween_property($Menu, "modulate:a", 0.0, 0.3).finished
	get_tree().change_scene_to_file("res://scenes/initial_cutscene/InitialCutscene.tscn")

func _on_exit_pressed():
	get_tree().quit()
