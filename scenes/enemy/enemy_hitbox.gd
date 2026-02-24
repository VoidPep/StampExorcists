extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	
	if body.has_method("receive_hit"):
		var hit_data = {
			"damage": 1
		}
		body.receive_hit(hit_data)
