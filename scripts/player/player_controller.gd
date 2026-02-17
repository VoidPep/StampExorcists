extends CharacterBody2D
class_name Player

@onready var step_dust_particles : GPUParticles2D = $Particles/StepDustParticles
@onready var dash_particles : GPUParticles2D = $Particles/DashParticles
@onready var state_machine = StateMachine

@export var animated_sprite : AnimatedSprite2D
@export var dash_cooldown_ui : TextureProgressBar

@onready var label : Label = $"../../../UI/CanvasLayer/Label"

const DASH_COOLDOWN := 0.6
const SPEED = 500.0
const DASH_SPEED := 1400.0
const DASH_DURATION := 0.09

var dash_cooldown_timer := 0.0
var can_dash : bool = true
var is_dashing : bool = false
var dash_direction: Vector2 = Vector2.ZERO
var last_horizontal := 1

func _physics_process(delta):
	if not can_dash:
		dash_cooldown_timer -= delta
		if dash_cooldown_timer <= 0:
			can_dash = true
			
func _process(delta):
	update_dash_ui()
	
func update_dash_ui():
	label.text = str(snapped(dash_cooldown_timer, 0.01))
	
	if can_dash:
		dash_cooldown_ui.value = 1
	else:
		var progress = 1.0 - (dash_cooldown_timer / DASH_COOLDOWN)
		dash_cooldown_ui.value = clamp(progress, 0, 1)
