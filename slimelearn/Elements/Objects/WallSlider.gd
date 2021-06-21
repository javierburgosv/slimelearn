extends Area2D

export(int) var xForce

func _on_WallSlider_body_entered(body):
	if body.name == "Player":
		body.nockback(Vector2(xForce,50))
		AudioStreamManager.play("res://Sound/slide.wav")
