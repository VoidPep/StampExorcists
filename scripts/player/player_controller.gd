extends CharacterBody2D
class_name Player

@onready var step_dust_particles : GPUParticles2D = $Particles/StepDustParticles
@onready var dash_particles : GPUParticles2D = $Particles/DashParticles
@onready var attack_hitbox_up : = $Brain/AttackHitboxUp/CollisionUp
@onready var attack_hitbox_down : = $Brain/AttackHitboxDown/CollisionDown
@onready var state_machine = StateMachine
@onready var effects : AnimationPlayer = $Effects
@onready var hit_timer : Timer = $HitTimer
@onready var camera : MainCamera = $Camera2D

@export var animated_sprite : AnimatedSprite2D
@export var dash_cooldown_ui : TextureProgressBar

const MAX_HP := 5
const DAMAGE := 1

const DASH_COOLDOWN := 0.6
const SPEED = 500.0
const DASH_SPEED := 1400.0
const DASH_DURATION := 0.09
const DEFAULT_IDLE := "idle_down"

var last_direction : String
var last_direction_vect_2 : Vector2 = Vector2.ZERO

var dash_cooldown_timer := 0.0
var can_dash : bool = true
var is_dashing : bool = false
var dash_direction: Vector2 = Vector2.ZERO
var last_horizontal := 1
var actual_hp := MAX_HP
var is_invincible : bool = false
var is_dead : bool = false

signal attack_pressed
signal dash_pressed
signal move_input(direction: Vector2)

func _ready():
	actual_hp = MAX_HP
	attack_hitbox_up.disabled = true
	attack_hitbox_down.disabled = true
	
	animated_sprite.frame_changed.connect(_on_frame_changed)
	animated_sprite.animation_finished.connect(_on_animation_finished)

func _physics_process(delta):
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	
	if direction != Vector2.ZERO:
		move_input.emit(direction)
	
	if Input.is_action_just_pressed("hit"):
		attack_pressed.emit()
	
	if Input.is_action_just_pressed("dash"):
		dash_pressed.emit()
	
	if not can_dash:
		dash_cooldown_timer -= delta
		if dash_cooldown_timer <= 0:
			can_dash = true
			
func _process(delta):
	update_dash_ui()
	
func update_dash_ui():
	#label.text = str(snapped(dash_cooldown_timer, 0.01))
	
	if can_dash:
		#dash_cooldown_ui.value = 1
		pass
	else:
		var progress = 1.0 - (dash_cooldown_timer / DASH_COOLDOWN)
		#dash_cooldown_ui.value = clamp(progress, 0, 1)

func _on_frame_changed():
	if animated_sprite.animation.begins_with("attack"):
		_attack_frame_event()
		return
	
	if animated_sprite.animation.begins_with("running"):
		_running_frame_event()
		return
	
func _running_frame_event():
	var frame = animated_sprite.frame
	
	if frame == 1 or frame == 5:
		GlobalAudioManager.play_random_sfx(GlobalAudioManager.WALK, -10.0)

			
func _attack_frame_event():
	if animated_sprite.frame == 4:
		enable_attack_hitbox()
	
	if animated_sprite.frame == 11:
		disable_attack_hitbox()
		
func _on_animation_finished():
	if not animated_sprite.animation.begins_with("attack"):
		disable_attack_hitbox()

func enable_attack_hitbox():
	if last_direction_vect_2.y < 0:
		attack_hitbox_up.disabled = false
	else:
		attack_hitbox_down.disabled = false

func disable_attack_hitbox():
	attack_hitbox_up.disabled = true
	attack_hitbox_down.disabled = true
	
func receive_hit(hit_data: Dictionary) -> void:
	if is_invincible or is_dead:
		return
	
	actual_hp -= hit_data.damage
	
	apply_knockback(hit_data.get("knockback", Vector2.ZERO))
	play_hit_feedback()
	
	# emit_signal("hp_changed", actual_hp)
	
	if actual_hp <= 0:
		die()
		
func play_hit_feedback() -> void:
	GlobalAudioManager.play_sfx(GlobalAudioManager.HIT, 0.0)
	
	is_invincible = true
	effects.play("blink")
	hit_timer.start()
	await hit_timer.timeout
	effects.play("RESET")
	is_invincible = false
	
func apply_knockback(force: Vector2) -> void:
	if force == Vector2.ZERO:
		return
	velocity = force * 400.0
	move_and_slide()
	await get_tree().create_timer(0.1).timeout
	
	camera.shake_strength = 8
	
	velocity = Vector2.ZERO

func die():
	pass
