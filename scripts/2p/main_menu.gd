extends Control

const SAVE_FILE_PATH = "user://highscore.save"
const PLAYER_COUNT_FILE = "user://player_count.save"
const PYTHON_SCRIPT_PATH = "res://scripts/oscrecognition.py"

var elapsed_time = 0  # Zeit in Sekunden
var timer_running = true

# Wird aufgerufen, wenn die Szene betreten wird.
func _ready():
	Globals.highscore = Globals.load_highscore()
	$Highscore_Score.text = str(Globals.highscore)

	var player_count = load_player_count()
	$VBoxContainer/OptionButton.select(player_count - 2)
	
	
	# Spielzeit laden und initialisieren
	Globals.elapsed_time = Globals.load_time()
	$Time_time.text = format_time(Globals.elapsed_time)
	
# Gibt die Zeit direkt in Sekunden als String zurück
func format_time(seconds: int) -> String:
	return str(int(seconds))

# Speichert die Zeit in `Globals`
func save_time():
	Globals.time_played = elapsed_time
	Globals.save_time()
	print("Gesamtspielzeit gespeichert:", elapsed_time / 60, "Minuten")

	
# Speichert den Highscore in einer Datei
func save_highscore():
	Globals.save_highscore()

func save_points():
	Globals.save_points()

func save_lostGames():
	Globals.save_lostGames()

# Speichert die Spieleranzahl in einer Datei
func save_player_count(player_count: int):
	var file := FileAccess.open(PLAYER_COUNT_FILE, FileAccess.WRITE)
	if file:
		file.store_string(str(player_count))
		file.close()
		print("Spieleranzahl gespeichert: ", player_count)
	else:
		print("Fehler beim Speichern der Spieleranzahl!")

# Lädt die Spieleranzahl aus der Datei
func load_player_count() -> int:
	var file := FileAccess.open(PLAYER_COUNT_FILE, FileAccess.READ)
	if file:
		var content := file.get_as_text()
		var player_count = int(content)
		print("Spieleranzahl geladen: ", player_count)
		file.close()
		return player_count
	else:
		print("Keine Spieleranzahl-Datei gefunden. Standardwert: 2.")
		return 2

func _on_game_start_pressed() -> void:
	
	var player_count = $VBoxContainer/OptionButton.get_selected() + 2
	save_player_count(player_count)

	if player_count == 2:
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	elif player_count == 3:
		get_tree().change_scene_to_file("res://scenes/main_3player.tscn")
	else:
		print("Ungültige Spieleranzahl ausgewählt:", player_count)
#	
	$Time_time.text = format_time(Globals.elapsed_time)
	
	
	

func _on_exit_pressed() -> void:
	
	$Time_time.text = format_time(Globals.elapsed_time)
	save_highscore()
	save_time()  # Zeit speichern beim Beenden
	get_tree().quit()
