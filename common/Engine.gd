extends Node

var max_hp = 6
var current_hp = 6
var money = 0
var weapon_damage = 1
var current_level = 1

var player = null
var fader = null

var players = null
var doodads = null
var items = null
var weapons = null
var enemies = null
var explosions = null

var knight = preload("res://characters/player/knight/Knight.tscn")
var ladder = preload("res://doodads/ladder/Ladder.tscn")

var brazier = preload("res://doodads/brazier/Brazier.tscn")
var coin = preload("res://doodads/coin/Coin.tscn")
var health_potion = preload("res://doodads/health_potion/HealthPotion.tscn")
var pillar = preload("res://doodads/pillar/Pillar.tscn")
var torch = preload("res://doodads/torch/Torch.tscn")

var brown_slime = preload("res://characters/enemies/brown_slime/BrownSlime.tscn")
var green_slime = preload("res://characters/enemies/green_slime/GreenSlime.tscn")
var crier = preload("res://characters/enemies/crier/Crier.tscn")
var little_devil = preload("res://characters/enemies/little_devil/LittleDevil.tscn")
var tuskie = preload("res://characters/enemies/tuskie/Tuskie.tscn")
var skull_face = preload("res://characters/enemies/skull_face/SkullFace.tscn")

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

	# need to do this after level generation, otherwise player doesn't exist
	player = get_node("/root/Main/Players/Player_Knight")

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
	print("Adding exit...")
	add_new(ladder, get_available_position(exists), doodads)
	
	# add torches to wall
	print("Adding wall torches...")
	add_new(torch, Vector2(120,8), doodads)
	add_new(torch, Vector2(200,8), doodads)
	
	# add obstacles
	print("Adding obstacles...")
	var num_obstacles = get_rand(1,100) % 4
	print("Number of obstacles to add: " + str(num_obstacles))
	for _i in num_obstacles:
		if get_rand(1,100) >= 50:
			var pillar_pos = get_available_position(exists)
			pillar_pos.y -= 20
			add_new(pillar, pillar_pos, doodads)
		else:
			add_new(brazier, get_available_position(exists), doodads)
	
	# add items
	print("Adding items...")
	var num_items = get_rand(1,100) % 7 + 2
	print("Number of items to add: " + str(num_items))
	for _i in num_items:
		if get_rand(1,100) >= 5:
			# most items should be coins
			add_new(coin, get_available_position(exists), items)
		elif get_rand(1,100) <= 10:
			# small chance to create large health potion
			var potion = add_new(health_potion, get_available_position(exists), items)
			potion.LARGE_POTION = true
		else:
			# add a small health potion
			add_new(health_potion, get_available_position(exists), items)
	
	# add enemies
	print("Adding enemies...")
	var enemy_hp_mod = current_level / 20
	var enemy_dmg_mod = clamp(current_level / 20, 0, 5)
	var min_enemies = 3
	var max_enemies = clamp(current_level / 5, min_enemies, 5) + 1 # min of 3-4 enemies, max of 5-6 enemies
	var num_enemies = get_rand(min_enemies, max_enemies)
	print("Number of enemies to add: " + str(num_enemies))
	for _i in num_enemies:
		# range increases with floor level, 100 max but rand can go higher than 100, making lower numbers less likely
		var enemy_roll = clamp(get_rand(0, 70 + current_level), 0, 100)
		print("Enemy roll: " + str(enemy_roll))
		if enemy_roll >= 60: # tier 3 enemies, strongest
			if get_rand(0,100) >= 50:
				var enemy = add_new(skull_face, get_available_position(exists), enemies)
				enemy.HP += enemy_hp_mod
				enemy.DAMAGE += enemy_dmg_mod
			else:
				var enemy = add_new(green_slime, get_available_position(exists), enemies)
				enemy.HP += enemy_hp_mod
				enemy.DAMAGE += enemy_dmg_mod
		elif enemy_roll >= 30: # tier 2 enemies
			if get_rand(0,100) >= 50:
				var enemy = add_new(little_devil, get_available_position(exists), enemies)
				enemy.HP += enemy_hp_mod
				enemy.DAMAGE += enemy_dmg_mod
			else:
				var enemy = add_new(brown_slime, get_available_position(exists), enemies)
				enemy.HP += enemy_hp_mod
				enemy.DAMAGE += enemy_dmg_mod
		else: # tier 1 enemies, weakest
			if get_rand(0,100) >= 50:
				var enemy = add_new(crier, get_available_position(exists), enemies)
				enemy.HP += enemy_hp_mod
				enemy.DAMAGE += enemy_dmg_mod
			else:
				var enemy = add_new(tuskie, get_available_position(exists), enemies)
				enemy.HP += enemy_hp_mod
				enemy.DAMAGE += enemy_dmg_mod
	
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
	return new_arrow

func add_explosion(pos: Vector2):
	var new_explosion = explosion.instance()
	new_explosion.position = pos
	new_explosion.playing = true
	explosions.add_child(new_explosion)
	
func add_new(preload_node, pos, dest_node):
	var new_node = preload_node.instance()
	new_node.position = pos
	dest_node.add_child(new_node)
	return new_node
