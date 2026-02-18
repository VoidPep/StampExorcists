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
	"running_left": "idle_left",
	"running_right": "idle_right",
	"running_up_left": "idle_up_left",
	"running_up_right": "idle_up_right",
	"running_down_left": "idle_down_left",
	"running_down_right": "idle_down_right"
}
