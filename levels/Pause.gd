extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Engine.current_hp <= 0:
		return
	
	if get_tree().paused:
		if Input.is_action_just_released("ui_cancel"):
			get_tree().paused = false
			visible = false
		elif Input.is_action_just_released("quit"):
			get_tree().change_scene("res://levels/menu/Menu.tscn")
			get_tree().paused = false
	elif Input.is_action_just_released("ui_cancel"):
		get_tree().paused = true
		visible = true

