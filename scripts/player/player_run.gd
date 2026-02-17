extends State
class_name PlayerRun

func physics_update(delta):
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	player.velocity = direction * player.SPEED
	player.move_and_slide()
		
	if direction == Vector2.ZERO:
		state_changer.emit(self, "playeridle")
		
	if direction.x != 0:
		player.last_horizontal = sign(direction.x)
		
	player.animated_sprite.play(get_run_animation(direction))
	
	if Input.is_action_just_pressed("dash") and direction != Vector2.ZERO and player.can_dash:
		player.can_dash = false
		player.dash_direction = direction.normalized()
		state_changer.emit(self, "playerdash")

func enter():
	player.step_dust_particles.emitting = true
		
func exit():
	player.step_dust_particles.emitting = false

func get_run_animation(direction: Vector2) -> String:
	var x = direction.x
	var y = direction.y
	
	if(x == 0 and y != 0):
		x = player.last_horizontal
		
	var key = Vector2(sign(x), sign(y))
	return RUN_ANIMATIONS.get(key, "idle")

const RUN_ANIMATIONS = {
	Vector2(-1, 0): "running_left",
	Vector2(1, 0): "running_right",
	Vector2(-1, -1): "running_up_left",
	Vector2(1, -1): "running_up_right",
	Vector2(-1, 1): "running_down_left",
	Vector2(1, 1): "running_down_right"
}
