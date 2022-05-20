extends Area2D


export var LARGE_POTION = false setget setLargePotion, getLargePotion

var _healing_potency = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setLargePotion(is_large):
	LARGE_POTION = is_large
	if is_large:
		_healing_potency = 5
		$AnimatedSprite.animation = "large"
	else:
		_healing_potency = 2
		$AnimatedSprite.animation = "small"
		
func getLargePotion():
   return LARGE_POTION
	
func _on_HealthPotion_area_entered(_area):
	get_node("/root/Main/AudioHealthPotion").play()
	queue_free()
	Engine.current_hp += _healing_potency
	if Engine.current_hp > Engine.max_hp:
		Engine.current_hp = Engine.max_hp
	Engine.add_potion_particles()
	print("Collected health potion, +" + str(_healing_potency) + " to hp. Current HP: " + str(Engine.current_hp))
