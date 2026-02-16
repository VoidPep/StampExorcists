extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_y := Input.get_axis("ui_up", "ui_down")
	#if directionY:
		#velocity.y = directionY * SPEED
	#else:
		#velocity.y = move_toward(velocity.y, 0, SPEED)
	
	var direction := Input.get_axis("ui_left", "ui_right")
	var speed = SPEED / 1.7 if direction and direction_y else SPEED
	
	move_pos(direction, "x", speed)
	move_pos(direction_y, "y", speed)
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		
func move_pos(direction, axis, speed):
	if direction:
		velocity[axis] = direction * speed
	else:
		velocity[axis] = move_toward(velocity[axis], 0, speed)

	move_and_slide()
