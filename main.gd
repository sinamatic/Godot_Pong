extends Sprite2D

var score := [0, 0]# 0:Player, 1: CPU
const PADDLE_SPEED : int = 500

func _on_ball_timer_timeout():
	$Ball.new_ball()

# Soll eig neues Spiel werden und Highscore speichern
func _on_score_left_body_entered(body):
	score[0] += 1
	$Hud/PlayerScore.text = str(score[0])
	$BallTimer.start()

# func ball-trifft-paddle
# score[0] += 1
# $Hud/PlayerScore.text = str(score[0])
# $BallTimer.start()
