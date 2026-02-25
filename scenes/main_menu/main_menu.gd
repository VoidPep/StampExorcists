extends Control

func _ready():
	$Menu/CenterContainer/VBoxContainer/Start.pressed.connect(_on_start_pressed)
	$Menu/CenterContainer/VBoxContainer/Exit.pressed.connect(_on_exit_pressed)
	
	GlobalAudioManager.play_music(GlobalAudioManager.MUSIC_MENU)

func _on_start_pressed():
	SceneManager.change_scene("res://scenes/initial_cutscene/InitialCutscene.tscn", $Menu)
	

func _on_exit_pressed():
	get_tree().quit()
