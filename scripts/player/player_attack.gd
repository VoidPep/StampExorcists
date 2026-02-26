extends State
class_name PlayerAttack

var attack_direction : Vector2
var attack_animation : String
var animation_finished := false

const ATTACK_FORCE := 420.0
const ATTACK_FRICTION := 1200.0

func enter():
	animation_finished = false
	
	var dir = player.last_direction_vect_2.normalized()
	
	if dir == Vector2.ZERO:
		dir = Vector2.DOWN
	
	apply_attack_impulse(dir)
	
	var animation = get_attack_animation(player.last_direction_vect_2)
	
	GlobalAudioManager.play_sfx(GlobalAudioManager.SWING)
	
	player.animated_sprite.play(animation)
	player.animated_sprite.animation_finished.connect(_on_animation_finished)
	player.attacked.emit()


func exit():
	if player.animated_sprite.animation_finished.is_connected(_on_animation_finished):
		player.animated_sprite.animation_finished.disconnect(_on_animation_finished)

func physics_update(delta):
	player.velocity = player.velocity.move_toward(Vector2.ZERO, ATTACK_FRICTION * delta)
	player.move_and_slide()

func _on_animation_finished():
	animation_finished = true
	player.move_and_slide()
	request_transition.emit("playeridle")

func get_attack_animation(direction: Vector2) -> String:
	var x = direction.x
	var y = direction.y
	
	if x == 0 and y != 0:
		x = player.last_horizontal
		
	player.animated_sprite.flip_h = true if x == 1 else false
	
	return ATTACK_ANIMATIONS.get(direction, "attack_down")

func apply_attack_impulse(direction: Vector2):
	player.velocity = direction * ATTACK_FORCE
	
func can_exit() -> bool:
	return animation_finished

const ATTACK_ANIMATIONS = {
	Vector2(-1, 0): "attack_down",
	Vector2(1, 0): "attack_down",
	Vector2(-1, -1): "attack_up",
	Vector2(1, -1): "attack_up",
	Vector2(-1, 1): "attack_down",
	Vector2(1, 1): "attack_down"
}
