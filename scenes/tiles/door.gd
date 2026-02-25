extends Node2D
class_name Door

@export var next_room: PackedScene
@export var tilemap: TileMapLayer
@export var door_cell: Vector2i
@export var open_tile_atlas_coords: Vector2i
@export var open_tile_source_id: int = 0
@export var tile_alternative: int = 0

@onready var blocker: StaticBody2D = $Blocker
@onready var trigger: Area2D = $TriggerArea

var is_open: bool = false

func _ready() -> void:
	trigger.body_entered.connect(_on_body_entered)
	lock()

func lock() -> void:
	is_open = false
	$Blocker/CollisionShape2D.disabled = false

func unlock() -> void:
	is_open = true
	$Blocker/CollisionShape2D.disabled = true
	_swap_door_tile()

func _swap_door_tile() -> void:
	if not tilemap:
		return
	
	tilemap.set_cell(door_cell, open_tile_source_id, open_tile_atlas_coords, tile_alternative)

func _on_body_entered(body: Node2D) -> void:
	if body is Player and is_open:
		get_tree().change_scene_to_packed(next_room)
