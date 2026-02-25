extends Node2D
class_name RoomController

signal room_cleared
signal wave_started(wave_index: int)

@export var enemy_scene: PackedScene
@export var spawn_points: Array[Marker2D] = []

const WAVES: Array[Dictionary] = [
	{ "count": 3, "interval": 0.6 },
	{ "count": 6, "interval": 0.3 },
	{ "count": 8, "interval": 0.25 },
	{ "count": 1, "interval": 0.0, "is_boss_wave": true },
]

var current_wave: int = 0
var active_enemies: int = 0
var room_active: bool = false

@onready var enemy_pool: Node2D = $EnemyPool

func _ready() -> void:
	var sp_node = get_node_or_null("SpawnPoints")
	if sp_node and spawn_points.is_empty():
		for child in sp_node.get_children():
			if child is Marker2D:
				spawn_points.append(child)
				
	start_room()

func start_room() -> void:
	if room_active:
		return
	room_active = true
	current_wave = 0
	_start_wave(current_wave)

func _start_wave(wave_index: int) -> void:
	var wave_data: Dictionary = WAVES[wave_index]
	emit_signal("wave_started", wave_index)

	var count: int = wave_data.get("count", 1)
	var interval: float = wave_data.get("interval", 0.5)

	for i in count:
		await get_tree().create_timer(interval * i + 0.1).timeout
		_spawn_enemy(wave_data)

func _spawn_enemy(wave_data: Dictionary) -> void:
	if not enemy_scene:
		return

	if spawn_points.is_empty():
		return

	var spawn_point: Marker2D = spawn_points[randi() % spawn_points.size()]
	var enemy: Enemy = enemy_scene.instantiate()

	if wave_data.get("is_boss_wave", false):
		enemy.set_meta("is_boss", true)

	enemy_pool.add_child(enemy)
	enemy.global_position = spawn_point.global_position

	active_enemies += 1
	enemy.tree_exited.connect(_on_enemy_died)

func _on_enemy_died() -> void:
	active_enemies -= 1

	if active_enemies <= 0 and room_active:
		await get_tree().create_timer(1.2).timeout
		_on_wave_cleared()

func _on_wave_cleared() -> void:
	current_wave += 1

	if current_wave >= WAVES.size():
		_on_room_cleared()
		return

	await get_tree().create_timer(1.5).timeout
	_start_wave(current_wave)

func _on_room_cleared() -> void:
	room_active = false
	emit_signal("room_cleared")
