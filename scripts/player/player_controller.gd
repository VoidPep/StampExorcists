extends CharacterBody2D
class_name Player

@onready var state_machine = StateMachine
@export var animated_sprite : AnimatedSprite2D

const SPEED = 300.0
const DASH_SPEED := 900.0
const DASH_DURATION := 0.15

var is_dashing : bool = false
var dash_direction: Vector2 = Vector2.ZERO
