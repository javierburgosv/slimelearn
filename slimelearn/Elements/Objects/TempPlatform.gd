extends StaticBody2D

var OnOff: bool = true
var sound: bool = false
var time: float
var ldif: int

func _ready():
	setTime(Global.difficulty)
	$DifCheck.start()
	
func setTime(dif):
	ldif = dif
	match (dif):
		1:
			time = 2.66
		2:
			time = 2.33
		3:
			time = 2.00
	
func _on_PlayerDetection_body_entered(body):
	if body.name == "Player":
		if OnOff:
			$Timer.start(time)
			$Clock.start()
			sound = true

func _on_Timer_timeout():
	if OnOff:
		$Clock.stop()
		$Sprite.play("destroy")
		yield(get_tree().create_timer(.1), "timeout")
		$Hitbox.disabled = true
		$Timer.start()
		$Effect.emitting = false
		if sound:
			AudioStreamManager.play("res://Sound/breaking.wav")
		Global.Player.doubleJump = 0
	else:
		$Sprite.play("destroy", true)
		yield(get_tree().create_timer(.1), "timeout")
		$Hitbox.disabled = false
		$Effect.emitting = true
		
	OnOff = !OnOff

func _on_Clock_timeout():
	AudioStreamManager.play("res://Sound/smallBreak.wav")

func _on_PlayerDetection_body_exited(body):
	if body.name == "Player":
		$Clock.stop()
		sound = false


func _on_DifCheck_timeout():
	var dif = Global.difficulty
	if ldif != dif:
		setTime(dif)
	else:
		return
