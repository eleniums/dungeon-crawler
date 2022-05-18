extends KinematicBody2D

export var MOVE_SPEED = 85
export var KNOCKBACK_SPEED = 400

var _velocity = Vector2()
var _knockback_timer = 0
var _knockback_dir = Vector2()
var _invincibility_timer = 0
var _weapon_cooldown = 0
var _flash = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		_velocity.x = MOVE_SPEED
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.animation = "move"
		$Weapon.flip_v = false
		if $Weapon.position.x < 0:
			$Weapon.position.x *= -1
	elif Input.is_action_pressed("ui_left"):
		_velocity.x = -MOVE_SPEED
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.animation = "move"
		$Weapon.flip_v = true
		if $Weapon.position.x > 0:
			$Weapon.position.x *= -1
	else:
		_velocity.x = 0
		
	if Input.is_action_pressed("ui_down"):
		_velocity.y = MOVE_SPEED
		$AnimatedSprite.animation = "move"
	elif Input.is_action_pressed("ui_up"):
		_velocity.y = -MOVE_SPEED
		$AnimatedSprite.animation = "move"
	else:
		_velocity.y = 0
		
	if _velocity == Vector2.ZERO:
		$AnimatedSprite.animation = "idle"
		
	if _weapon_cooldown > 0:
		_weapon_cooldown -= delta
	if Input.is_action_just_pressed("ui_select") and _weapon_cooldown <= 0:
		$Weapon.visible = true
		$Weapon/WeaponHitbox/CollisionShape2D.disabled = false
		$WeaponTimer.start()
		_weapon_cooldown = 0.45
		
	if _invincibility_timer > 0:
		_invincibility_timer -= delta
		
	if _knockback_timer > 0:
		_knockback_timer -= delta
		_velocity = move_and_slide(_knockback_dir * KNOCKBACK_SPEED, Vector2.UP)
	else:
		_velocity = move_and_slide(_velocity, Vector2.UP)


func is_invincible():
	return _invincibility_timer > 0

func initiate_knockback(dir: Vector2):
	_knockback_dir = dir
	_knockback_timer = 0.05
	_invincibility_timer = 0.75
	
	modulate = Color(1,0,0,1)
	_flash = false
	$FlashTimer.start()
	
func disable():
	visible = false
	set_process(false)
	$Weapon/WeaponHitbox/CollisionShape2D.set_deferred("disabled",true)
	$Hitbox/CollisionShape2D.set_deferred("disabled",true)

func _on_FlashTimer_timeout():
	if _flash:
		modulate = Color(1,0,0,1)
		_flash = false
	else:
		modulate = Color(1,1,1,1)
		_flash = true
	if _invincibility_timer > 0:
		$FlashTimer.start()
	else:
		modulate = Color(1,1,1,1)

func _on_WeaponTimer_timeout():
	$Weapon.visible = false
	$Weapon/WeaponHitbox/CollisionShape2D.disabled = true
