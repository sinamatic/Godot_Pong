extends Node

var highscore: int = 0

var speedmultiplier: float

const SAVE_FILE_PATH = "user://highscore.save"
# Speicherort auf Mac: '/Users/sinasteinmuller/Library/Application Support/Godot/app_userdata/Pong_1p_osc/highscore.save'


# Speichert den Highscore in einer Datei
func save_highscore():
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(str(highscore))
		file.close()
		print("Highscore gespeichert: ", highscore)
	else:
		print("Fehler beim Speichern des Highscores!")

# Lädt den Highscore aus der Datei
func load_highscore() -> int:
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file:
		var content := file.get_as_text()
		highscore = int(content)
		print("Highscore geladen: ", highscore)
		file.close()
		return highscore
	else:
		print("Keine Highscore-Datei gefunden. Standardwert: 0.")
		return 0
