extends Node2D

func _ready():
	pass


func _on_VanishOn_body_entered(body):
	if body.name == "Player":
		$Vanish.play("Vanish")


func _on_VanishOn_body_exited(body):
	if body.name == "Player":
		$Vanish.stop()
		self.modulate = Color(1,1,1,1)



