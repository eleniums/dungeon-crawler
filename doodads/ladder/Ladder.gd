extends AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func is_open():
	return animation == "open"

func open_ladder():
	animation = "open"

func _on_Hitbox_area_entered(_area):
	if is_open():
		get_node("/root/Main/SFX/AudioNextLevel").play()
		Engine.player.disable()
		Engine.fader.fade_to_black()
