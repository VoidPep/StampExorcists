extends Node2D

func _ready() -> void:
	GlobalAudioManager.play_music(GlobalAudioManager.MUSIC_COMBAT)
	
	var player = $Enviroment/CombatRoom/CharacterBody2D
	

func _process(delta: float) -> void:
	pass
