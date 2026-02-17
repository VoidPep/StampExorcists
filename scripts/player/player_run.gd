extends State
class_name PlayerRun

func physics_update(delta):
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	player.velocity = direction * player.SPEED
	player.move_and_slide()
		
	if direction == Vector2.ZERO:
		state_changer.emit(self, "playeridle")
		
	player.animated_sprite.play(get_run_animation(direction))
	
	if Input.is_action_just_pressed("dash") and direction != Vector2.ZERO:
		player.dash_direction = direction.normalized()
		state_changer.emit(self, "playerdash")

func get_run_animation(direction: Vector2) -> String:
	var key = Vector2(sign(direction.x), sign(direction.y))
	return RUN_ANIMATIONS.get(key, "idle")

const RUN_ANIMATIONS = {
	Vector2(-1, 0): "running_left",
	Vector2(1, 0): "running_right",
	Vector2(-1, -1): "running_up_left",
	Vector2(1, -1): "running_up_right",
	Vector2(-1, 1): "running_down_left",
	Vector2(1, 1): "running_down_right"
}
