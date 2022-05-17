extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_released("ui_cancel"):
		get_tree().quit()
		
	update_money()
	update_health()
	
	if Engine.current_hp == 0:
		$HUD/GameOver.visible = true

func update_money():
	$HUD/Money.text = "$" + str(Engine.money)
	
func update_health():
	if Engine.current_hp >= 2:
		$HUD/Health1.animation = "full"
	if Engine.current_hp >= 4:
		$HUD/Health2.animation = "full"
	if Engine.current_hp >= 6:
		$HUD/Health3.animation = "full"
	
	if Engine.current_hp == 1:
		$HUD/Health1.animation = "half"
	if Engine.current_hp == 3:
		$HUD/Health2.animation = "half"
	if Engine.current_hp == 5:
		$HUD/Health3.animation = "half"
	
	if Engine.current_hp <= 0:
		$HUD/Health1.animation = "empty"
	if Engine.current_hp <= 2:
		$HUD/Health2.animation = "empty"
	if Engine.current_hp <= 4:
		$HUD/Health3.animation = "empty"
