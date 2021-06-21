extends Area2D

var active: bool = false

func _on_Slider_body_entered(body):
	if body.name == "Player" and active:
		var dir = 70
		
		if self.rotation_degrees != 0:
			dir = -dir
		
		body.nockback(Vector2(dir,50))
		AudioStreamManager.play("res://Sound/slide.wav")
		


func _on_Activate_body_entered(body):
	if body.name == "Player":
		active = true


func _on_Activate_body_exited(body):
	if body.name == "Player":
		active = false
