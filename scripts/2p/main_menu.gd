extends Control

const SAVE_FILE_PATH = "user://highscore.save"
const PLAYER_COUNT_FILE = "user://player_count.save"
const PYTHON_SCRIPT_PATH = "res://scripts/oscrecognition.py"  # Pfad zum Python-Skript


# Wird aufgerufen, wenn die Szene betreten wird.
func _ready():
	# print("Skript-Pfad: ", ProjectSettings.globalize_path(PYTHON_SCRIPT_PATH))
	
	# Highscore aus der Datei laden und in Globals speichern
	Globals.highscore = Globals.load_highscore()
	$Highscore_Score.text = str(Globals.highscore)

	# Spieleranzahl aus der Datei laden und setzen
	var player_count = load_player_count()
	$VBoxContainer/OptionButton.select(player_count - 2)  # Annahme: Option 0 = 2 Spieler, Option 1 = 3 Spieler
	
# Speichert den Highscore in einer Datei
func save_highscore():
	Globals.save_highscore()

func save_time():
	Globals.save_time()

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
		return 2  # Standardwert: 2 Spieler

# Führt das Python-Skript aus
func run_python_script():
	var python_executable = "python3"  # Setze den Python-Interpreter
	var script_path = ProjectSettings.globalize_path(PYTHON_SCRIPT_PATH)

	# PackedStringArray für die Konsolenausgabe
	var output: PackedStringArray = PackedStringArray()
	var error_output: PackedStringArray = PackedStringArray()

	# Python-Skript ausführen und Fehlerausgabe erfassen
	# var result = OS.execute(python_executable, [script_path], output, error_output)
	var result = OS.execute(python_executable, [script_path], output)
	
	if result == OK:
		print("Python-Skript erfolgreich ausgeführt.")
		print("Skript-Ausgabe: ", "\n".join(output))
	else:
		print("Fehler beim Ausführen des Python-Skripts. Fehlercode: ", result)
		print("Fehlerausgabe: ", "\n".join(error_output))
		print("Absoluter Skriptpfad: ", script_path)

func _on_game_start_pressed() -> void:
	# Spieleranzahl speichern
	var player_count = $VBoxContainer/OptionButton.get_selected() + 2  # Option 0 = 2 Spieler, Option 1 = 3 Spieler
	save_player_count(player_count)

	# Szenenwechsel basierend auf der Spieleranzahl
	if player_count == 2:
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	elif player_count == 3:
		get_tree().change_scene_to_file("res://scenes/main_3player.tscn")
	else:
		print("Ungültige Spieleranzahl ausgewählt:", player_count)
	# Python-Skript ausführen
	run_python_script()
	

func _on_exit_pressed() -> void:
	# Highscore speichern beim Beenden des Spiels
	save_highscore()
	get_tree().quit()
