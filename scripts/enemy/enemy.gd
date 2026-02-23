extends CharacterBody2D
class_name Enemy

@onready var effects = $Effects
@onready var hitTimer = $HitTimer 

@export var max_health: int = 999999
var current_health: int

func _ready() -> void:
	current_health = max_health
	effects.play("RESET")

func _physics_process(delta: float) -> void:
	move_and_slide()

func receive_hit(hit_data: Dictionary):
	apply_damage(hit_data.damage)
	apply_knockback(hit_data.knockback)
	apply_stamp()
	play_hit_feedback()

func apply_damage(amount: int):
	current_health -= amount

func apply_knockback(force: Vector2):
	velocity = force
	move_and_slide()

func apply_stamp():
	pass

func play_hit_feedback():
	effects.play("blink")
	hitTimer.start()
	await hitTimer.timeout
	effects.play("RESET")
