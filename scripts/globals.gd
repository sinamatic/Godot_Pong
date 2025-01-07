extends Node

var highscore: int = 0
var time_played: int = 0
var points_saved: int = 0
var lostGames: int = 0
var timer_running: bool = false
var elapsed_time: int = 0


var speedmultiplier: float

const SAVE_FILE_PATH_HIGHSCORE = "user://highscore.save"
# Speicherort auf Mac: '/Users/sinasteinmuller/Library/Application Support/Godot/app_userdata/Pong_1p_osc/highscore.save'
const SAVE_FILE_PATH_TIME = "user://time.save"
const SAVE_FILE_PATH_POINTS = "user://points.save"
const SAVE_FILE_PATH_LOSTGAMES = "user://lostGames.save"

# Speichert den Highscore in einer Datei
func save_highscore():
	var file := FileAccess.open(SAVE_FILE_PATH_HIGHSCORE, FileAccess.WRITE)
	if file:
		file.store_string(str(highscore))
		file.close()
		print("Highscore gespeichert: ", highscore)
	else:
		print("Fehler beim Speichern des Highscores!")

# Lädt den Highscore aus der Datei
func load_highscore() -> int:
	var file := FileAccess.open(SAVE_FILE_PATH_HIGHSCORE, FileAccess.READ)
	if file:
		var content := file.get_as_text()
		highscore = int(content)
		print("Highscore geladen: ", highscore)
		file.close()
		return highscore
	else:
		print("Keine Highscore-Datei gefunden. Standardwert: 0.")
		return 0

func save_time():
	var file := FileAccess.open(SAVE_FILE_PATH_TIME, FileAccess.WRITE)
	if file:
		file.store_string(str(time_played))
		file.close()
		print("Spielzeit gespeichert: ", time_played, "Sekunden")
	else:
		print("Fehler beim Speichern der Spielzeit!")

func load_time() -> int:
	var file := FileAccess.open(SAVE_FILE_PATH_TIME, FileAccess.READ)
	if file:
		var content := file.get_as_text()
		time_played = int(content)
		print("Spielzeit geladen: ", time_played, "Sekunden")
		file.close()
		return time_played
	else:
		print("Keine Spielzeit-Datei gefunden. Erstelle neue Datei mit Standardwert: 0.")
		time_played = 0
		save_time()
		return time_played


# Speichert die Punkte in einer Datei
func save_points():
	var file := FileAccess.open(SAVE_FILE_PATH_POINTS, FileAccess.WRITE)
	if file:
		file.store_string(str(points_saved))
		file.close()
		print("Punkte gespeichert: ", points_saved)
	else:
		print("Fehler beim Speichern der Punkte!")

# Lädt die Punkte aus einer Datei
func load_points() -> int:
	var file := FileAccess.open(SAVE_FILE_PATH_POINTS, FileAccess.READ)
	if file:
		var content := file.get_as_text()
		points_saved = int(content)
		print("Punkte geladen: ", points_saved)
		file.close()
		return points_saved
	else:
		print("Keine Punkte-Datei gefunden. Standardwert: 0.")
		return 0

# Speichert die Anzahl der verlorenen Spiele in einer Datei
func save_lostGames():
	var file := FileAccess.open(SAVE_FILE_PATH_LOSTGAMES, FileAccess.WRITE)
	if file:
		file.store_string(str(lostGames))
		file.close()
		print("Verlorene Spiele gespeichert: ", lostGames)
	else:
		print("Fehler beim Speichern der verlorenen Spiele!")

# Lädt die Anzahl der verlorenen Spiele aus einer Datei
func load_lostGames() -> int:
	var file := FileAccess.open(SAVE_FILE_PATH_LOSTGAMES, FileAccess.READ)
	if file:
		var content := file.get_as_text()
		lostGames = int(content)
		print("Verlorene Spiele geladen: ", lostGames)
		file.close()
		return lostGames
	else:
		print("Keine Datei für verlorene Spiele gefunden. Standardwert: 0.")
		return 0
