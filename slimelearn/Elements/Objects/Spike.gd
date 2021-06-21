extends Area2D

export(int) var energy = 10

func _on_Spike_body_entered(body):
	if body.name == "Player":
		if body.motion.x > 0:
			body.nockback(Vector2(-energy, 0))
		elif body.motion.x < 0:
			body.nockback(Vector2(energy, 0))
			
		yield(get_tree().create_timer(1), "timeout")
