extends Sprite2D

const PADDLE_SPEED : int = 500

func _on_ball_timer_timeout():
	$Ball.new_ball()
	



func _on_deadzone_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	$BallTimer.start()
