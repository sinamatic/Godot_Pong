extends StaticBody2D

var win_height: int
var p_height: int
var p_width: int
var win_width: int
var osc_value: float  # Aktueller OSC-Wert
var paddle_position_x: float
var paddle_position_y: float

@onready var osc_receiver2: Node = $OSCReceiver2

# Called when the node enters the scene tree for the first time.
func _ready():
	win_height = get_viewport_rect().size.y
	win_width = get_viewport_rect().size.x
	p_height = $ColorRect.get_size().y
	p_width = $ColorRect.get_size().x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		position.y -= get_parent().PADDLE_SPEED * delta
	elif Input.is_action_pressed("ui_down"):
		position.y += get_parent().PADDLE_SPEED * delta
	elif Input.is_action_pressed("ui_left"):
		position.x -= get_parent().PADDLE_SPEED * delta
	elif Input.is_action_pressed("ui_right"):
		position.x += get_parent().PADDLE_SPEED * delta
		
# Überprüfe alle eingehenden Nachrichten
	if osc_receiver2 and osc_receiver2.has_method("get"):
		var target_server = $OSCServer2

	# Initialisiere Variablen für X und Y
		var normalized_x = position.x
		var normalized_y = position.y

		if target_server:
			for address in target_server.incoming_messages.keys():
				var osc_value = target_server.incoming_messages[address][0]
				target_server.incoming_messages.erase(address)  # Nachricht verarbeiten und entfernen

				# Skaliere den OSC-Wert auf den Bildschirmbereich
				var normalized_value = -clamp(osc_value, -1, 1)  # Normalisiere den Wert auf [-1, 1]

				if address.ends_with("/x"):
					# Berechne Zielposition für X
					normalized_x = win_width / 2.0 + normalized_value * (win_width / 2.0 - p_width / 2.0)
					print("P2: Empfangene Nachricht: X, Zielposition X:", normalized_x, "Normalisierter X Wert:", normalized_value)

				elif address.ends_with("/y"):
					# Berechne Zielposition für Y
					normalized_y = win_height / 2.0 + normalized_value * (win_height / 2.0 - p_height / 2.0)
					print("P2: Empfangene Nachricht: Y, Zielposition Y:", normalized_y, "Normalisierter Y Wert:", normalized_value)

		# Aktualisiere Paddle-Position für X und Y
		position.x = lerp(float(position.x), float(normalized_x), delta * 5.0)  # Glättung für X
		position.y = lerp(float(position.y), float(normalized_y), delta * 5.0)  # Glättung für Y

	#limit paddle movement to window
	# position.x = clamp(position.x, 0, win_width - p_width)
	# position.y = clamp(position.y, win_height / 2 - p_height, win_height - p_height)
