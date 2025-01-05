extends Sprite2D

const PADDLE_SPEED : int = 500

func _on_ball_timer_timeout():
	$Ball.new_ball()

# Soll eig neues Spiel werden und Highscore speichern
func _on_score_body_entered(body):

	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
	$BallTimer.start()
