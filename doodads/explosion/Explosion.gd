extends AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Explosion_animation_finished():
	queue_free()
