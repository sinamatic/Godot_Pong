extends Control

const SAVE_FILE_PATH = "user://highscore.save"

# Wird aufgerufen, wenn die Szene betreten wird.
func _ready():
	# Highscore aus der Datei laden und in Globals speichern
	Globals.highscore = Globals.load_highscore()
	# Anzeige des geladenen Highscores
	$Highscore_Score.text = str(Globals.highscore)


func _on_game_start_pressed() -> void:
	# Szenenwechsel, Highscore bleibt in Globals bestehen
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_exit_pressed() -> void:
	# Highscore speichern beim Beenden des Spiels
	Globals.save_highscore()
	get_tree().quit()
