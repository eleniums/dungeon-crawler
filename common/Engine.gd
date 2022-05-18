extends Node

var max_hp = 6
var current_hp = 6
var money = 0
var weapon_damage = 1

var player = null
var fader = null

var players = null
var doodads = null
var items = null
var weapons = null
var enemies = null
var explosions = null

var knight = preload("res://characters/player/knight/Knight.tscn")
var arrow = preload("res://weapons/arrow/Arrow.tscn")
var explosion = preload("res://doodads/explosion/Explosion.tscn")

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	fader = get_node("/root/Main/HUD/Fader")
	
	players = get_node("/root/Main/Players")
	doodads = get_node("/root/Main/Doodads")
	items = get_node("/root/Main/Items")
	weapons = get_node("/root/Main/Weapons")
	enemies = get_node("/root/Main/Enemies")
	explosions = get_node("/root/Main/Explosions")
	
	# used for level generation so seeds can be reproduced
	rng.randomize() # initialize with a random time-based seed
	#rng.seed = hash("testseed") # initialize with a user provided seed

	reset_level()

	player = get_node("/root/Main/Players/Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func reset_level():
	print("Generating level...")
	
	# game has 18 x 10 usable squares
	var exists = []
	for _i in range(180):
		exists.append(false)
	
	# add player first to make sure they have a spot
	print("Adding player...")
	var player_pos = get_available_position(exists)
	player_pos.y -= 8 # adjust player position since sprite has empty space
	add_new(knight, player_pos, players)
	
	# add exit second to make sure it can be placed
	
	# add obstacles
	
	# add items
	
	# add enemies
	
	# all done, fade in and begin!
	fader.fade_in()
	
	print("Finished with level generation.")

func get_available_position(exists) -> Vector2:
	# find an empty spot in the grid
	var loc = get_rand(0,179)
	while exists[loc] == true:
		loc = get_rand(0,179)		
	
	# spot is now in use
	exists[loc] = true
	
	# get equivalent position
	var pos = Vector2()
	pos.x = 16 * (loc % 18 + 1) + 8
	pos.y = 16 * (loc / 18 + 1) + 8
	print("loc: " + str(loc) + ", " + str(pos))
	
	return pos

func get_rand(low_inclusive:int, high_inclusive:int):
	# generates a random number in the given range, inclusive
	return rng.randi_range(low_inclusive, high_inclusive)

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
	
func add_new(preload_node, pos, dest_node):
	var new_node = preload_node.instance()
	new_node.position = pos
	dest_node.add_child(new_node)
