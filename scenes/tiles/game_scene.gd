extends Node2D

func _ready() -> void:
	GlobalAudioManager.play_music(GlobalAudioManager.MUSIC_COMBAT)
	
	var player = $Enviroment/CombatRoom/CharacterBody2D
	

func _process(delta: float) -> void:
	pass

func _on_game_ended():
	SceneManager.change_scene("res://scenes/final_cutscene/FinalCutscene.tscn")
