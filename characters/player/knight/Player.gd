extends KinematicBody2D

export var MOVE_SPEED = 85

var _velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		_velocity.x = MOVE_SPEED
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.animation = "move"
	elif Input.is_action_pressed("ui_left"):
		_velocity.x = -MOVE_SPEED
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.animation = "move"
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
		
	move_and_slide(_velocity, Vector2.UP)
