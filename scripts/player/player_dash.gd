extends State
class_name PlayerDash

var timer := 0.0

func enter():
	timer = player.DASH_DURATION
	player.dash_particles.emitting = true
	
func exit():
	player.can_dash = false
	player.dash_cooldown_timer = player.DASH_COOLDOWN
	player.dash_particles.emitting = false
	
func physics_update(delta):
	timer -= delta
	
	GlobalAudioManager.play_sfx(GlobalAudioManager.DASH)
	player.velocity = player.dash_direction * player.DASH_SPEED
	player.move_and_slide()
	update_animated_sprite()
	
	if timer <= 0:
		request_transition.emit("playeridle")

func update_animated_sprite():
	var frame_texture = player.animated_sprite.sprite_frames.get_frame_texture(
		player.animated_sprite.animation,	
		player.animated_sprite.frame	
	)
	
	player.dash_particles.texture = frame_texture
