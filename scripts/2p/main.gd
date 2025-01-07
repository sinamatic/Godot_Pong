extends Sprite2D

const PADDLE_SPEED : int = 500
var timer_running : bool = false

func _on_ball_timer_timeout():
	$Ball.new_ball()
	print(Globals.timer_running)
	if Globals.timer_running:
		Globals.elapsed_time += delta  # Addiere die vergangene Zeit (in Sekunden)
		# $Time_time.text = format_time(Globals.elapsed_time)
		print(Globals.elapsed_time)


func _on_deadzone_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
	$BallTimer.start()
