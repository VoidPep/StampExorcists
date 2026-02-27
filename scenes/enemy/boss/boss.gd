extends Enemy
class_name MiniBoss

enum BossState { IDLE, CHARGE, STOMP, ROAR, COOLDOWN }

@export var charge_speed: float = 900.0
@export var charge_duration: float = 0.6
@export var stomp_radius: float = 120.0
@export var rock_count: int = 4
@export var rock_delay: float = 1.2

var charge_velocity: Vector2 = Vector2.ZERO
var state: BossState = BossState.IDLE
var attack_timer: float = 2.0
var attack_cooldown: float = 2.0
var attack_index: int = 0
var is_attacking: bool = false

@onready var stomp_area: Area2D = $StompArea
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var falling_rock_scene: PackedScene

func _ready() -> void:
	super._ready()
	stomp_area.body_entered.connect(_on_stomp_hit)
	stomp_area.monitoring = false

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	match state:
		BossState.IDLE:
			update_direction()
			move_towards_player(delta)
			attack_timer -= delta
			if attack_timer <= 0 and not is_attacking:
				_choose_next_attack()

		BossState.CHARGE:
			velocity = charge_velocity

		BossState.STOMP, BossState.ROAR, BossState.COOLDOWN:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()

func _choose_next_attack() -> void:
	is_attacking = true
	attack_index = (attack_index + 1) % 3
	match attack_index:
		0: _start_charge()
		1: _start_stomp()
		2: _start_roar()

func _start_charge() -> void:
	state = BossState.CHARGE
	
	charge_velocity = (player.global_position - global_position).normalized() * charge_speed
	
	await get_tree().create_timer(charge_duration).timeout
	charge_velocity = Vector2.ZERO
	velocity = Vector2.ZERO
	_end_attack()

func _start_stomp() -> void:
	state = BossState.STOMP
	velocity = Vector2.ZERO
	
	sprite.play("boss_stomp")
	await sprite.animation_finished
	player.camera.shake_strength = 12
	sprite.play("enemy_idle")
	
	stomp_area.monitoring = true
	await get_tree().create_timer(0.2).timeout
	stomp_area.monitoring = false
	
	_end_attack()

func _on_stomp_hit(body) -> void:
	if body.has_method("receive_hit"):
		var hit_data = {
			"damage": 2,
			"knockback": (body.global_position - global_position).normalized()
		}
		body.receive_hit(hit_data)

func _start_roar() -> void:
	state = BossState.ROAR
	velocity = Vector2.ZERO
	
	sprite.play("boss_roar")
	GlobalAudioManager.play_sfx(preload("res://audio/sfx/scream.wav"))
	
	player.camera.shake_strength = 8
	await sprite.animation_finished
	
	await _spawn_falling_rocks()
	_end_attack()

func _spawn_falling_rocks() -> void:
	if not falling_rock_scene:
		return
	
	for i in rock_count:
		var offset = Vector2(
			randf_range(-150, 150),
			randf_range(-180, 180)
		)
		await get_tree().create_timer(randf_range(0.0, 0.3)).timeout
		
		var rock = falling_rock_scene.instantiate()
		get_parent().add_child(rock)
		rock.global_position = player.global_position + offset
		rock.delay = randf_range(0.8, 1.6)
		
		await get_tree().create_timer(randf_range(0.1, 0.3)).timeout

func _end_attack() -> void:
	state = BossState.IDLE
	attack_timer = attack_cooldown
	is_attacking = false
