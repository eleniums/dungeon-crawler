extends KinematicBody2D

export var MOVE_SPEED = 40
export var DIRECTION = Vector2.RIGHT
export var TOUCH_DAMAGE = 1

var _velocity = Vector2()
var _timer = 0
var _hit_timer = 0
var _arrow_cooldown = 0

var _hp = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	_timer = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _hit_timer > 0:
		_hit_timer -= delta
		modulate = Color(1,0,0,1)
	else:
		modulate = Color(1,1,1,1)
	
	ai(delta)
	handle_movement(delta)

func ai(delta):
	_timer -= delta
	if _timer <= 0:
		if DIRECTION == Vector2.RIGHT:
			DIRECTION = Vector2.LEFT
		elif DIRECTION == Vector2.LEFT:
			DIRECTION = Vector2.RIGHT
		_timer = 2
		
	if _arrow_cooldown > 0:
		_arrow_cooldown -= delta
		$RayCast2D.enabled = false
	else:
		$RayCast2D.enabled = true
	if $RayCast2D.is_colliding():
		print("Monster sees player! Firing arrow.")
		var pos = Vector2(position.x, position.y + $AnimatedSprite.frames.get_frame("idle", 0).get_height() / 4)
		Engine.fire_arrow(pos, DIRECTION)
		_arrow_cooldown = 3.0

func handle_movement(delta):
	if DIRECTION.x > 0:
		_velocity.x = MOVE_SPEED
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.animation = "move"
		if $RayCast2D.cast_to.x < 0:
			$RayCast2D.cast_to.x *= -1
	elif DIRECTION.x < 0:
		_velocity.x = -MOVE_SPEED
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.animation = "move"
		if $RayCast2D.cast_to.x > 0:
			$RayCast2D.cast_to.x *= -1
	else:
		_velocity.x = 0
		
	if DIRECTION.y > 0:
		_velocity.y = MOVE_SPEED
		$AnimatedSprite.animation = "move"
	elif DIRECTION.y < 0:
		_velocity.y = -MOVE_SPEED
		$AnimatedSprite.animation = "move"
	else:
		_velocity.y = 0
		
	if _velocity == Vector2.ZERO:
		$AnimatedSprite.animation = "idle"
		
	var collisions = move_and_collide(_velocity * delta)
	if collisions:
		DIRECTION *= -1


func _on_Hitbox_area_entered(area):
	if area.is_in_group("player"):
		var dir = Vector2.RIGHT
		if area.global_position.x < global_position.x:
			dir = Vector2.LEFT
		Engine.hurt_player(TOUCH_DAMAGE, dir)
	elif area.is_in_group("player_weapon"):
		_hp -= Engine.weapon_damage
		_hit_timer = 0.15
		print("Monster took " + str(Engine.weapon_damage) + " damage. HP remaining: " + str(_hp))
		if _hp <= 0:
			queue_free()
			print("Monster defeated.")
			var pos = Vector2(position.x, position.y + $AnimatedSprite.frames.get_frame("idle", 0).get_height() / 4)
			Engine.add_explosion(pos)
