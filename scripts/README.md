# Dependencies

## für Mac für die Spracherkennung

```
brew install portaudio
```

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

- Download dataOSC aus dem Appstore
