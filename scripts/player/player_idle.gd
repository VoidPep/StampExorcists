extends State
class_name PlayerIdle

var sprite : AnimatedSprite2D

func enter():
	player.animated_sprite.play(IDLE_ANIMATIONS.get(player.last_direction, player.DEFAULT_IDLE))
	
func update(delta: float):
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	player.velocity = Vector2.ZERO
	player.move_and_slide()
	
	if direction != Vector2.ZERO:
		state_changer.emit(self, "playerrun")

const IDLE_ANIMATIONS = {
	"running_up": "idle_up",
	"running_down": "idle_down"
}
