extends CharacterBody2D
class_name Enemy

@onready var effects = $Effects
@onready var hitTimer = $HitTimer 
@onready var hurt_box = $HurtHitbox
@onready var hit_box = $Area2D/GeneralHitbox

@export var speed: float = 95.0
@export var acceleration: float = 500.0
@export var friction: float = 600.0
@export var max_health: int = 3

var current_health: int
var is_dead: bool = false
var direction: Vector2 = Vector2.ZERO
var player: Player

func _ready() -> void:
	current_health = max_health
	effects.play("RESET")
	
	player = get_tree().get_first_node_in_group("Player")
	
	$AnimatedSprite2D.material = $AnimatedSprite2D.material.duplicate()

func _physics_process(delta: float) -> void:
	update_direction()
	move_towards_player(delta)
	move_and_slide()

func receive_hit(hit_data: Dictionary, callback_function):
	apply_damage(hit_data.damage, callback_function)
	apply_knockback(hit_data.knockback)
	apply_stamp()
	play_hit_feedback()

func apply_damage(amount: int, callback_function: Callable):
	current_health -= amount
	
	if callback_function:
		callback_function.call()
	
	if current_health <= 0:
		die()

func apply_knockback(force: Vector2):
	velocity = force * 500
	move_and_slide()
	
	await get_tree().create_timer(0.025).timeout
	velocity = Vector2.ZERO

func apply_stamp():
	pass

func play_hit_feedback():
	if is_dead:
		return
	
	effects.play("blink")
	hitTimer.start()
	await hitTimer.timeout
	effects.play("RESET")
	
func die():
	if is_dead:
		return
		
	is_dead = true
	
	hurt_box.set_deferred("disabled", true)
	hit_box.set_deferred("disabled", true)
	
	velocity = Vector2.ZERO
	
	await get_tree().create_timer(0.4).timeout
	
	var mat = $AnimatedSprite2D.material
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/dissolve_amount", 1.0, 0.6)
	await tween.finished
	GlobalAudioManager.play_sfx(GlobalAudioManager.ENEMY_DEATH, 10)
	
	queue_free()

func update_direction() -> void:
	direction = (player.global_position - global_position).normalized()

func move_towards_player(delta: float) -> void:
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
		$AnimatedSprite2D.flip_h = direction.x > 0
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
