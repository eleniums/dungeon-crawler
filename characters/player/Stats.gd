extends Node

var max_hp = 6
var current_hp = 6
var money = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hurt_player(damage):
	current_hp -= damage
	print("Player takes " + str(damage) + " damage. Current HP: " + str(current_hp))
