# Pong in Godot mit cooler Steuerung

Ziel ist es, dass man das SPiel Pong entweder alleine oder zu zweit gegeneinander lustig spielen kann.

Aktuell kann man das linke Paddle mit W und A hoch und runter bewegen, für das Rechte Paddle arbeite ich grad an was coolerem. Ich hab erst ein Pythonskript für die Spracherkennung gemacht, das findest du im Repo bei scripts/voicerecognition und kannst das direkt ausführen.

Die Sprachereknnung war aber bisschen scheiße, weil einzelne Wörter zu kurz sind, also „up“ erkennt er gar nicht, „hoch“ nur manchmal weil das ch scheiße ist, Test und Hallo geht, aber wird häufig auch zu „test test“ oder „hallo hallo“. Plan war: Python nimmt übers Mikro die Sprache auf und schreibt es in eine Textdatei voice_input.txt, Godot liest die Textdatei und das Paddle bewegt sich.
Aber weil das mit Python schon nicht richtig ging hab ichs über den Haufen geworfen.

## Dependencies

```
brew install portaudio
```

- pyaudio
- SpeechRecognition

Backup vom Voicerecognitioncode bei Player2 in Godot

```godot
# Player2 Voicecontrol

extends StaticBody2D

var win_height : int
var p_height : int
var speed_multiplier : float = 1.0
var voice_command : String = ""
var volume : float = 0.0

# Set up a FileAccess object to read input from the Python script
var voice_file_path : String = "res://scripts/voice_input.txt"

# Called when the node enters the scene tree for the first time.
func _ready():
	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Read the latest voice input from the file
	if FileAccess.file_exists(voice_file_path):
		var voice_file = FileAccess.open(voice_file_path, FileAccess.READ)
		if voice_file:
			var content = voice_file.get_as_text().strip_edges()
			voice_file.close()
			if content:
				var parts = content.split(",")
				if parts.size() >= 2:
					voice_command = parts[0]
					volume = float(parts[1])

	# Adjust paddle speed based on volume
	speed_multiplier = volume / 100.0 # Assuming volume is 0 to 100

	# Move paddle based on voice command
	if voice_command == "up":
		position.y -= get_parent().PADDLE_SPEED * speed_multiplier * delta
	elif voice_command == "down":
		position.y += get_parent().PADDLE_SPEED * speed_multiplier * delta

	# Limit paddle movement to window
	position.y = clamp(position.y, p_height / 2, win_height - p_height / 2)


```

- funktioniert nicht richtig, Wörter zu kurz

# OSC Steuerung

Neue Idee dann: DataOSC App am Handy und dann mit hoch bzw. runter kippen vom Handy das paddle steuern. In scripts/oscrecognition ist der Code, es werden auch Daten vom Handy und der App empfangen und ausgegeben, aber in Godot kommen die Daten irgendwie noch nicht an und ich weiß nicht warum

- Download dataOSC aus dem Appstore
- Eigene ip adresse des Computers rausfinden
- in DataOSC App die IP Adresse des Computers eingeben
- im Pythonscript bei IP = "192.168.2.118" die eigene IP Adresse eingeben

# ToDo

DONE - Kommunikation zwischen Python und Godot oder die Daten von DataOSC direkt in Godot?
DONE - 2 Handys mit DataOSC für 2 Player verwenden und 2 Ports festlegen?
2025-01-03

- [x] Startbildschirm erstellen
- [x] Normalisierung in Skripten rausnehmen und Y Position begrenzen
- [x] Keyboardsteuerung optimieren, sodass Paddle nicht mehr ausm Spiel raus kann
- [ ] Design überarbeiten
- [x] Score überarbeiten, wenn Ball auf Paddle trifft solls punkte geben, wenn kein Paddle trifft, dann GameOver
- [x] Highscoreliste erstellen und neuen Highscore eintragen wenn Spiel vorbei ist
- [x] Fehler beheben, dass die ganze zeit hits gesammelt werden wenn paddle den ball anschiebt
- [ ] Gamename überlegen und kurzbeschreibung erstellen
- [ ] Geschwindigkeit über die Zeit anpassen
- [ ] Geschwindigkeit im Spiel anzeigen lassen
- [ ] Vollbild anpassen bei jedem Bildschirm

Optional

- [ ] Paddlefarben auswählen
- [ ] Highscore liste erstellen und über button aufrufbar machen?
- [ ] Ggf. Schwierigkeit mit der Zeit erhöhen: Paddle wird zB Schmaler nach 2 min oder nach 20 scores?
  - Geschwindigkeit vom Ball schneller
  - Ballgröße verändern
  - Paddle breiter oder schmaler machen
  - Paddlegeschwindigkeit ändern
- [ ] Münzen random einblenden, wenn Münze mit Paddle getroffen Score +1 und Paddle breiter?
- [ ] Score ggf. speichern und davon dann in Ballshop neue Bälle kaufen, zB Dicker oder Rechteckig mit anderer Physik o.Ä.
