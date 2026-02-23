extends State
class_name PlayerIdle

var sprite : AnimatedSprite2D

func exit():
	disconnect_event(player.attack_pressed, _on_attack_pressed)

func enter():
	player.animated_sprite.play(IDLE_ANIMATIONS.get(player.last_direction, player.DEFAULT_IDLE))
	
	connect_event(player.attack_pressed, _on_attack_pressed)
	
func _on_attack_pressed():
	request_transition.emit("playerattack")
	
func update(delta: float):
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	
	player.velocity = Vector2.ZERO
	player.move_and_slide()
	
	if direction != Vector2.ZERO:
		request_transition.emit("playerrun")

const IDLE_ANIMATIONS = {
	"running_up": "idle_up",
	"running_down": "idle_down"
}
