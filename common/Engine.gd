extends Node

var max_hp = 6
var current_hp = 6
var money = 0
var weapon_damage = 1

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Main/Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hurt_player(damage, dir):
	if !player.is_invincible():
		current_hp -= damage
		print("Player takes " + str(damage) + " damage. Current HP: " + str(current_hp))
		player.initiate_knockback(dir)
