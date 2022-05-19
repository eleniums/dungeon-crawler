extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Coin_area_entered(_area):
	queue_free()
	Engine.money += 1
	print("Collected coin, +1 to money. Total money: " + str(Engine.money))
	Engine.add_coin_particles(position)
