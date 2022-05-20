extends Node2D

enum MenuState {
	MAIN,
	INSTRUCTIONS,
	CREDITS,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	change_menu(MenuState.MAIN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $CanvasLayer/Instructions.visible and Input.is_action_just_pressed("ui_accept"):
		change_menu(MenuState.MAIN)
	elif $CanvasLayer/Credits.visible and Input.is_action_just_pressed("ui_accept"):
		change_menu(MenuState.MAIN)
	elif $CanvasLayer/MainMenu.visible and Input.is_action_just_pressed("ui_cancel"):
		Engine.save_scores()
		get_tree().quit()

func change_menu(new_menu):
	hide_menus()
	match new_menu:
		MenuState.MAIN:
			$CanvasLayer/MainMenu/Version.text = Engine.version
			$CanvasLayer/MainMenu/Hiscores.text = "Hi-score - Coins: $" + str(Engine.hiscore_coins) + ", Floors: " + str(Engine.hiscore_floors)
			$CanvasLayer/MainMenu.visible = true
			$CanvasLayer/MainMenu/VBoxContainer/Start.grab_focus()
		MenuState.INSTRUCTIONS:
			$CanvasLayer/Instructions.visible = true
		MenuState.CREDITS:
			$CanvasLayer/Credits.visible = true

func hide_menus():
	$CanvasLayer/MainMenu.visible = false
	$CanvasLayer/Instructions.visible = false
	$CanvasLayer/Credits.visible = false

func _on_Start_pressed():
	$CanvasLayer/Fader.fade_to_black()

func _on_Instructions_pressed():
	change_menu(MenuState.INSTRUCTIONS)

func _on_Credits_pressed():
	change_menu(MenuState.CREDITS)

func _on_Quit_pressed():
	Engine.save_scores()
	get_tree().quit()

func _on_Fader_faded_to_black():
	# fading complete, start game
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://levels/main/Main.tscn")
