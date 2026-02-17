extends State
class_name PlayerDash

var timer := 0.0

func enter():
	timer = player.DASH_DURATION
	
func physics_update(delta):
	timer -= delta
	
	player.velocity = player.dash_direction * player.DASH_SPEED
	player.move_and_slide()
	
	if timer <= 0:
		state_changer.emit(self, "playeridle")
