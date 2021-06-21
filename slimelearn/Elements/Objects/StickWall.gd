extends StaticBody2D

func _on_Activador_body_entered(body):
	if body.name == "Player":
#		print("Activado")
		Global.Player.wallJump = true

func _on_Activador_body_exited(body):
	if body.name == "Player":
#		print("Desactivado")
		Global.Player.wallJump = false
