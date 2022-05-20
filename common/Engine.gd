extends Node

var version = "v0.1.0"

var max_hp = 6
var current_hp = 6
var money = 0
var weapon_damage = 1
var current_level = 1

var hiscore_coins = 0
var hiscore_floors = 0

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
var coin_particles = preload("res://doodads/coin/CoinParticles.tscn")
var potion_particles = preload("res://doodads/health_potion/PotionParticles.tscn")

var seeded_rng = RandomNumberGenerator.new()
var rng = RandomNumberGenerator.new()

var save_pass = "notsecure"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_scores()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func start_game():
	fader = get_node("/root/Main/HUD/Fader")
	
	players = get_node("/root/Main/Players")
	doodads = get_node("/root/Main/Doodads")
	items = get_node("/root/Main/Items")
	weapons = get_node("/root/Main/Weapons")
	enemies = get_node("/root/Main/Enemies")
	explosions = get_node("/root/Main/Explosions")

	# used for level generation so seeds can be reproduced
	seeded_rng.randomize() # initialize with a random time-based seed
	#seeded_rng.seed = hash("testseed") # initialize with a user provided seed

	# used for random events not based on the level seed
	rng.randomize()

	# zero out default stats
	max_hp = 6
	current_hp = 6
	money = 0
	weapon_damage = 1
	current_level = 1

	reset_level()

func reset_level():
	print("Generating level...")

	# check for hiscore
	if Engine.current_level > Engine.hiscore_floors:
		Engine.hiscore_floors = Engine.current_level
	
	# clear out all existing stuff first
	delete_children(weapons)
	delete_children(enemies)
	delete_children(items)
	delete_children(doodads)
	delete_children(explosions)
	delete_children(players)
	
	# game has 18 x 10 usable squares
	var exists = []
	for _i in range(180):
		exists.append(false)
	
	# add player first to make sure they have a spot
	print("Adding player...")
	var player_pos = get_available_position(exists)
	player_pos.y -= 8 # adjust player position since sprite has empty space
	player = add_new(knight, player_pos, players)
	
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
	var enemy_hp_mod = current_level / 30
	var enemy_dmg_mod = clamp(current_level / 30, 0, 5)
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
				var skull_pos = get_available_position(exists)
				skull_pos.y -= 10
				var enemy = add_new(skull_face, skull_pos, enemies)
				enemy.HP += enemy_hp_mod
				enemy.DAMAGE += enemy_dmg_mod
				enemy.COINS_HELD += get_rand(0,3)
			else:
				var enemy = add_new(green_slime, get_available_position(exists), enemies)
				enemy.HP += enemy_hp_mod
				enemy.DAMAGE += enemy_dmg_mod
				enemy.COINS_HELD += get_rand(0,3)
		elif enemy_roll >= 30: # tier 2 enemies
			if get_rand(0,100) >= 50:
				var enemy = add_new(little_devil, get_available_position(exists), enemies)
				enemy.HP += enemy_hp_mod
				enemy.DAMAGE += enemy_dmg_mod
				enemy.COINS_HELD += get_rand(0,3)
			else:
				var enemy = add_new(brown_slime, get_available_position(exists), enemies)
				enemy.HP += enemy_hp_mod
				enemy.DAMAGE += enemy_dmg_mod
				enemy.COINS_HELD += get_rand(0,3)
		else: # tier 1 enemies, weakest
			if get_rand(0,100) >= 50:
				var enemy = add_new(crier, get_available_position(exists), enemies)
				enemy.HP += enemy_hp_mod
				enemy.DAMAGE += enemy_dmg_mod
				enemy.COINS_HELD += get_rand(0,3)
			else:
				var enemy = add_new(tuskie, get_available_position(exists), enemies)
				enemy.HP += enemy_hp_mod
				enemy.DAMAGE += enemy_dmg_mod
				enemy.COINS_HELD += get_rand(0,3)
	
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
	return seeded_rng.randi_range(low_inclusive, high_inclusive)

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
	get_node("/root/Main/SFX/AudioDeath").play()
	var new_explosion = explosion.instance()
	new_explosion.position = pos
	new_explosion.playing = true
	explosions.add_child(new_explosion)

func add_coin_drop(pos: Vector2):
	var new_coin = coin.instance()
	pos.x += rng.randi_range(-8,8)
	pos.y += rng.randi_range(-8,8)
	new_coin.position = pos
	items.add_child(new_coin)
	
func add_coin_particles(pos: Vector2):
	var new_coin_particles = coin_particles.instance()
	new_coin_particles.position = pos
	new_coin_particles.emitting = true
	explosions.add_child(new_coin_particles)
	
func add_potion_particles():
	var new_potion_particles = potion_particles.instance()
	new_potion_particles.position.y += 8
	new_potion_particles.emitting = true
	player.add_child(new_potion_particles)
	
func add_new(preload_node, pos, dest_node):
	var new_node = preload_node.instance()
	new_node.position = pos
	dest_node.add_child(new_node)
	return new_node

func delete_children(node):
	for n in node.get_children():
		n.queue_free()

func save_scores():
	var save_dict = {
		"hiscore_coins" : hiscore_coins,
		"hiscore_floors" : hiscore_floors,
	}
	var save_game = File.new()
	save_game.open_encrypted_with_pass("user://scores.save", File.WRITE, save_pass)
	save_game.store_line(to_json(save_dict))
	save_game.close()
	print("Saved player hi-scores.")

func load_scores():
	var save_game = File.new()
	if not save_game.file_exists("user://scores.save"):
		return # no save to load so just skip it
	save_game.open_encrypted_with_pass("user://scores.save", File.READ, save_pass)
	var save_dict = parse_json(save_game.get_line())
	save_game.close()
	hiscore_coins = save_dict["hiscore_coins"]
	hiscore_floors = save_dict["hiscore_floors"]
	print("Loaded player hi-scores.")
