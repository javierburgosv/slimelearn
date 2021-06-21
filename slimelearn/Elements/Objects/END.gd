extends Area2D

func _on_END_body_entered(body):
	if body.name == "Player":
		print("victoria")
		AudioStreamManager.play("res://Sound/win.wav")
		body.visible = false
		Global.gstate = Global.gstates.end
		$Animations.play("End")
		body.global_position = Vector2(56.335, 162.311)
		Global.hasSkin = true



func _on_Animations_animation_finished(anim_name):
	if anim_name == "End":
		Global.money = 0
		Global.diamonds = []
		# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
