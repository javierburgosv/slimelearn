extends StaticBody2D

export(bool) var DesactivarHitbox

func _ready():
	DesactivarHitbox = $CollisionShape2D.disabled

# warning-ignore:unused_argument
func _process(delta):
	$CollisionShape2D.disabled = DesactivarHitbox
