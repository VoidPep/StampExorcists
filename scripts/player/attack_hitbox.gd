extends Area2D

func _on_AttackHitbox_body_entered(body):
	if body.has_method("take_damage"):
		pass
		#body.take_damage(player.attack_damage)
