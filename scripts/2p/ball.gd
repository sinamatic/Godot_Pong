extends CharacterBody2D

var win_size : Vector2
const START_SPEED : int = 500
const ACCEL : int = 75
var speed : int
var dir : Vector2
const MAX_Y_VECTOR : float = 0.7
var score = 0
var activescoring = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# win_size = $"../Playground/Background".size
	win_size = get_viewport_rect().size
	$"../Hud/PlayerScore".text = str(score)
	$"../Hud/HighScore Score".text = str(Globals.highscore)

func new_ball():
	score = 0
	$"../Hud/PlayerScore".text = str(score)
	$"../Hud/HighScore Score".text = str(Globals.highscore)
	#randomize start position and direction
	# position.x = win_size.x / 2
	# position.y = randi_range(200, win_size.y - 200)
	speed = START_SPEED
	dir = random_direction()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(dir * speed * delta)
	var collider
	if collision:
		collider = collision.get_collider()
		#if ball hits paddle
		if collider == $"../Players/Player1" or collider == $"../Players/Player2":			
			
			if (activescoring):
				speed += ACCEL
				score += 1
				
			dir = new_direction(collider)
				
			$"../Hud/PlayerScore".text = str(score)
			
			activescoring = 0
			# print("activescoring:")
			# print(activescoring)
			
			if (score > Globals.highscore):
				Globals.highscore = score
				Globals.save_highscore()
				$"../Hud/HighScore Score".text = str(Globals.highscore)

		#if it hits a wall
		else:
			dir = dir.bounce(collision.get_normal())
			activescoring = 1
			# print("activescoring:")
			# print(activescoring)

func random_direction():
	var new_dir := Vector2()
	# Wählt zufällig, ob der Ball nach links oder rechts startet
	new_dir.x = [1, -1].pick_random()
	# Setzt die Y-Komponente auf einen negativen Wert, damit der Ball nach oben geht
	new_dir.y = randf_range(-1, -0.5) # Negative Werte zwischen -1 und -0.1
	return new_dir.normalized()


# legacy-funktion: problem wenn ball seitlich ans paddle kommt
#func new_direction(collider):
	#var ball_y = position.y
	#var pad_y = collider.position.y
	#var dist = ball_y - pad_y
	#var new_dir := Vector2()
	#
	##flip the horizontal direction
	#if dir.x > 0:
		#new_dir.x = 1
	#else:
		#new_dir.x = -1
	## new_dir.y =  (dist / (collider.p_height / 2)) * MAX_Y_VECTOR
	#new_dir.y =  (dist / (randf_range(0.75, 1.25) * collider.p_height / 2)) * MAX_Y_VECTOR
	#return new_dir.normalized()


func new_direction(collider):
	var ball_y = position.y
	var ball_x = position.x
	var pad_y = collider.position.y
	var pad_x = collider.position.x
	var dist_y = ball_y - pad_y
	var dist_x = ball_x - pad_x
	var new_dir := Vector2()
	
	# Prüfen, ob der Ball seitlich getroffen hat
	if abs(dist_x) > collider.p_width / 2:
		# Ball trifft die Seitenkante
		new_dir.x = -dir.x  # Horizontalrichtung umkehren
		new_dir.y = dir.y   # Vertikalrichtung bleibt gleich
	else:
		# Ball trifft die Ober- oder Unterseite
		new_dir.x = dir.x  # Horizontalrichtung bleibt gleich
		new_dir.y = (dist_y / (collider.p_height / 2)) * MAX_Y_VECTOR

	return new_dir.normalized()
