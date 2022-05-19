extends ColorRect

enum FadeState {
	NO_FADE,
	FADE_IN,
	FADE_TO_BLACK,
}

signal faded_in
signal faded_to_black

var _state = FadeState.NO_FADE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match _state:
		FadeState.FADE_TO_BLACK:
			var result = lerp(get_modulate(), Color(0,0,0,1), 0.2)
			set_modulate(result)
			if is_equal_approx(result.a, 1):
				emit_signal("faded_to_black")
				_state = FadeState.NO_FADE
		FadeState.FADE_IN:
			var result = lerp(get_modulate(), Color(0,0,0,0), 0.2)
			set_modulate(result)
			if is_equal_approx(result.a, 0):
				emit_signal("faded_in")
				_state = FadeState.NO_FADE

func fade_to_black():
	set_modulate(Color(0,0,0,0))
	_state = FadeState.FADE_TO_BLACK
	
func fade_in():
	set_modulate(Color(0,0,0,1))
	_state = FadeState.FADE_IN
