extends Area2D

func _on_Wings_body_entered(body):
	if body.name == "Player":
		AudioStreamManager.play("res://Sound/powerup.wav")
		Global.doubleJump += 1
		self.queue_free()
