
extends StaticBody2D

var win_height : int
var win_width : int
var p_height : int
var p_width : int

# Called when the node enters the scene tree for the first time.
func _ready():
	win_height = get_viewport_rect().size.y
	win_width = get_viewport_rect().size.x
	p_height = $ColorRect.get_size().y
	p_width = $ColorRect.get_size().x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		position.y -= get_parent().PADDLE_SPEED * delta
	elif Input.is_action_pressed("ui_down"):
		position.y += get_parent().PADDLE_SPEED * delta
	elif Input.is_action_pressed("ui_left"):
		position.x -= get_parent().PADDLE_SPEED * delta
	elif Input.is_action_pressed("ui_right"):
		position.x += get_parent().PADDLE_SPEED * delta
		
	

	#limit paddle movement to window
	position.x = clamp(position.x, 0, win_width - p_width)
	position.y = clamp(position.y, win_height / 2 - p_height, win_height - p_height)
