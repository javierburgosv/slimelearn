extends Path2D

export(int) var spd = 10
onready var follow = $mplatFollow

func _process(delta):
	follow.set_offset(follow.get_offset() + spd * delta)
