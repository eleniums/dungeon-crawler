extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_tree().paused:
		print("game is paused")
		if Input.is_action_just_released("ui_cancel"):
			print("unpause game")
			get_tree().paused = false
			visible = false
		elif Input.is_action_just_released("quit"):
			get_tree().quit()
	elif Input.is_action_just_released("ui_cancel"):
		print("pause game")
		get_tree().paused = true
		visible = true
