extends State
class_name PlayerDead

func enter():
	player.velocity = Vector2.ZERO
	player.set_process(false)
	player.set_physics_process(false)
	
	player.animated_sprite.play("death")
	player.animated_sprite.animation_finished.connect(_on_death_animation_finished, CONNECT_ONE_SHOT)
	
	GlobalAudioManager.play_music(GlobalAudioManager.MUSIC_GAME_OVER)

func _on_death_animation_finished():
	await player.get_tree().create_timer(1.0).timeout
	
	player.player_died.emit()

func exit():
	player.set_process(true)
	player.set_physics_process(true)

func can_exit() -> bool:
	return false
