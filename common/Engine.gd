extends Node

var max_hp = 6
var current_hp = 6
var money = 0
var weapon_damage = 1

var player = null
var weapons = null
var explosions = null

var arrow = preload("res://weapons/arrow/Arrow.tscn")
var explosion = preload("res://doodads/explosion/Explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Main/Player")
	weapons = get_node("/root/Main/Weapons")
	explosions = get_node("/root/Main/Explosions")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func hurt_player(damage, dir):
	if !player.is_invincible():
		current_hp -= damage
		print("Player takes " + str(damage) + " damage. Current HP: " + str(current_hp))
		player.initiate_knockback(dir)

func fire_arrow(pos: Vector2, dir: Vector2):
	var new_arrow = arrow.instance()
	new_arrow.position = pos
	new_arrow.DIRECTION = dir
	weapons.add_child(new_arrow)

func add_explosion(pos: Vector2):
	var new_explosion = explosion.instance()
	new_explosion.position = pos
	new_explosion.playing = true
	explosions.add_child(new_explosion)
	
