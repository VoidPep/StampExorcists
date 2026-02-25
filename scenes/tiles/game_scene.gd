extends Node2D

func _ready() -> void:
	GlobalAudioManager.play_music(GlobalAudioManager.MUSIC_COMBAT)

func _process(delta: float) -> void:
	pass
