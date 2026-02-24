extends Area2D

@onready var player : Player = $"../.."
@onready var camera : MainCamera = $"../../Camera2D"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	var hit_direction = player.last_direction_vect_2
	
	if body.has_method("receive_hit"):
		var hit_data = {
			"damage": player.DAMAGE,
			"knockback": Vector2(hit_direction.x, hit_direction.y)
		}
		body.receive_hit(hit_data, on_hit)

func on_hit():
	camera.shake_strength = 10
	GlobalAudioManager.play_sfx(GlobalAudioManager.HIT)
