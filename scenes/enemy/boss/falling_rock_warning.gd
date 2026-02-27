extends Node2D
class_name FallingRockWarning

@export var delay: float = 1.2
@export var damage: int = 2
@export var warning_radius: float = 40.0

@onready var warning_circle: Polygon2D = $WarningCircle
@onready var rock_sprite: Sprite2D = $RockSprite
@onready var rock_area: Area2D = $RockArea

const FALL_HEIGHT: float = -120.0
const SHADOW_MIN_SCALE: float = 0.3

func _ready() -> void:
	warning_circle.polygon = _make_circle(warning_radius, 32)
	warning_circle.color = Color(1, 0.2, 0.2, 0.5)
	
	rock_area.monitoring = false
	rock_area.body_entered.connect(_on_rock_hit)
	
	rock_sprite.position.y = FALL_HEIGHT
	rock_sprite.scale = Vector2(0.3, 0.3)
	rock_sprite.modulate.a = 0.0
	
	warning_circle.scale = Vector2(SHADOW_MIN_SCALE, SHADOW_MIN_SCALE)
	warning_circle.modulate.a = 0.5
	
	_animate()

func _make_circle(radius: float, points: int) -> PackedVector2Array:
	var verts = PackedVector2Array()
	for i in points:
		var angle = (TAU / points) * i
		verts.append(Vector2(cos(angle), sin(angle)) * radius)
	return verts

func _animate() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(rock_sprite, "position:y", 0.0, delay)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(rock_sprite, "scale", Vector2(1.0, 1.0), delay)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(rock_sprite, "modulate:a", 1.0, delay * 0.4)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_LINEAR)
	
	tween.tween_property(warning_circle, "scale", Vector2(1.0, 1.0), delay)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_QUAD)
	
	tween.tween_property(warning_circle, "modulate:a", 0.9, delay)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_LINEAR)
	
	tween.chain()
	tween.tween_callback(_on_impact)

func _on_impact() -> void:
	rock_area.monitoring = true
	
	var impact_tween = create_tween()
	impact_tween.set_parallel(true)
	impact_tween.tween_property(rock_sprite, "scale", Vector2(1.4, 0.6), 0.08)\
		.set_trans(Tween.TRANS_EXPO)
	impact_tween.chain()
	impact_tween.tween_property(rock_sprite, "scale", Vector2(0.9, 1.1), 0.06)
	impact_tween.chain()
	impact_tween.tween_property(rock_sprite, "scale", Vector2(1.0, 1.0), 0.08)
	
	await get_tree().create_timer(0.15).timeout
	rock_area.monitoring = false
	
	var fade = create_tween()
	fade.tween_property(rock_sprite, "modulate:a", 0.0, 0.4)
	fade.parallel().tween_property(warning_circle, "modulate:a", 0.0, 0.4)
	await fade.finished
	queue_free()

func _on_rock_hit(body) -> void:
	if body.has_method("receive_hit"):
		var hit_data = {
			"damage": damage,
			"knockback": (body.global_position - global_position).normalized()
		}
		body.receive_hit(hit_data)
