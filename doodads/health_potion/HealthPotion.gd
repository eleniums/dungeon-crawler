extends Area2D


export var LARGE_POTION = false setget setLargePotion, getLargePotion

var healing_potency = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setLargePotion(is_large):
	LARGE_POTION = is_large
	if is_large:
		healing_potency = 6
		$AnimatedSprite.animation = "large"
	else:
		healing_potency = 2
		$AnimatedSprite.animation = "small"
		
func getLargePotion():
   return LARGE_POTION
	
func _on_HealthPotion_area_entered(_area):
	self.set_process(false)
	self.hide()
	Stats.current_hp += healing_potency
	if Stats.current_hp > Stats.max_hp:
		Stats.current_hp = Stats.max_hp
	print("collected health potion, +" + str(healing_potency) + "to hp. Current HP: " + str(Stats.current_hp))
