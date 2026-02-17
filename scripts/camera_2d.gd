extends Camera2D

@export var target: Node2D
@export var look_ahead_distance := 80.0
@export var look_ahead_speed := 8.0
@export var smoothing_speed := 14.0

@export var shake_strength := 0.0
@export var shake_decay := 5.0

var look_offset := Vector2.ZERO

func _process(delta):
	if not target:
		return

	var velocity = target.get("velocity")

	normalize_offset(velocity, delta)
	
	if Input.is_key_pressed(KEY_SPACE):
		shake_strength = 10
	
	shake_camera(delta)

	var desired_position = target.global_position + look_offset
	global_position = global_position.lerp(desired_position, delta * smoothing_speed)
	
func normalize_offset(velocity, delta):
	if velocity.length() > 10:
		var desired_offset = velocity.normalized() * look_ahead_distance
		look_offset = look_offset.lerp(desired_offset, delta * look_ahead_speed)
		return
	
	look_offset = look_offset.lerp(Vector2.ZERO, delta * look_ahead_speed)
	
func shake_camera(delta):
	if shake_strength < 0:
		offset = Vector2.ZERO
		return
		
	shake_strength = lerp(shake_strength, 0.0, delta * shake_decay)
	offset = Vector2(
		randf_range(-shake_strength, shake_strength),
		randf_range(-shake_strength, shake_strength)
	)
