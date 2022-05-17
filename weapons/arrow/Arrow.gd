extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var DIRECTION = Vector2.RIGHT
export var SPEED = 100
export var DAMAGE = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if DIRECTION == Vector2.RIGHT:
		rotation_degrees = 90
	else:
		rotation_degrees = 270
	
	var collisions = move_and_collide(DIRECTION * SPEED * delta)
	if collisions:
		queue_free() # arrow hit a wall or something


func _on_Hitbox_area_entered(area):
	queue_free()
	var dir = Vector2.RIGHT
	if area.global_position.x < global_position.x:
		dir = Vector2.LEFT
	Engine.hurt_player(DAMAGE, dir)
