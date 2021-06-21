extends PathFollow2D


#Montarse
func _on_PlayerSensor_body_entered(body):
	if body.name == "Player":
		body.nodoPlataforma = self
		

func _on_PlayerSensor_body_exited(body):
	if body.name == "Player":
		body.nodoPlataforma = null
		
