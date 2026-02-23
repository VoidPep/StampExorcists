extends State
class_name PlayerRun

var actual_direction : String = ""

func enter():
	player.step_dust_particles.emitting = true
	connect_event(player.attack_pressed,_on_attack_pressed)
		
func exit():
	player.last_direction = actual_direction
	player.step_dust_particles.emitting = false
	disconnect_event(player.attack_pressed,_on_attack_pressed)

func physics_update(delta):
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	
	player.velocity = direction * player.SPEED
	player.move_and_slide()
		
	if direction == Vector2.ZERO:
		request_transition.emit("playeridle")
		return
		
	if direction.x != 0:
		player.last_horizontal = sign(direction.x)
		
	actual_direction = get_run_animation(direction)
	player.animated_sprite.play(actual_direction)
	
	if Input.is_action_just_pressed("dash") and direction != Vector2.ZERO and player.can_dash:
		player.can_dash = false
		player.dash_direction = direction.normalized()
		request_transition.emit("playerdash")
	
func _on_attack_pressed():
	request_transition.emit("playerattack")
	
func get_run_animation(direction: Vector2) -> String:
	var x = direction.x
	var y = direction.y
	
	if(x == 0 and y != 0):
		x = player.last_horizontal
		
	var key = Vector2(sign(x), sign(y))
	
	player.last_direction_vect_2 = key
	player.animated_sprite.flip_h = true if sign(x) == 1 else false
	
	return RUN_ANIMATIONS.get(key, player.DEFAULT_IDLE)

const RUN_ANIMATIONS = {
	Vector2(-1, 0): "running_down",
	Vector2(1, 0): "running_down",
	Vector2(-1, -1): "running_up",
	Vector2(1, -1): "running_up",
	Vector2(-1, 1): "running_down",
	Vector2(1, 1): "running_down"
}
