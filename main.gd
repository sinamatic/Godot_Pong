extends Sprite2D

var score = 0
const PADDLE_SPEED : int = 500
signal hit_player

func _on_ball_timer_timeout():
	$Ball.new_ball()

# Soll eig neues Spiel werden und Highscore speichern
func _on_score_left_body_entered(body):
	
	$BallTimer.start()

func on_ball_hit():
	score += 1
	$Hud/PlayerScore.text = str(score)
