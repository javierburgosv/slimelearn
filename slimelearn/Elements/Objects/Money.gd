extends Area2D

export(int) var id
export(int) var value = 1

func _ready():
#	$Animate.play("Floating")
	colected()


func _on_Money_body_entered(body):
	if body.name == "Player":
		AudioStreamManager.play("res://Sound/powerup.wav")
		Global.money += value
		Global.diamonds.append(id)
		print(Global.diamonds)
		self.queue_free()

func colected():
	for item in Global.diamonds:
		if id == item:
			self.queue_free()
