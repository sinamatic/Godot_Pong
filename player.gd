extends StaticBody2D

var win_height: int
var p_height: int
var p_width: int
var win_width: int
var osc_value: float  # Aktueller OSC-Wert
var paddle_position_x: float
var paddle_position_y: float

@onready var osc_receiver: Node = $OSCReceiver

func _ready():
	win_height = get_viewport_rect().size.y
	win_width = get_viewport_rect().size.x
	p_height = $ColorRect.get_size().y


func _process(delta):
	if Input.is_key_pressed(KEY_W):
		position.y -= get_parent().PADDLE_SPEED * delta
	elif Input.is_key_pressed(KEY_S):
		position.y += get_parent().PADDLE_SPEED * delta
	elif Input.is_key_pressed(KEY_A):
		position.x -= get_parent().PADDLE_SPEED * delta
	elif Input.is_key_pressed(KEY_D):
		position.x += get_parent().PADDLE_SPEED * delta

	# Limit paddle movement to window
	position.x = clamp(position.x, 0, win_width - p_width)
	position.y = clamp(position.y, win_height / 2 - p_height, win_height - p_height)

	# Überprüfe eingehende Nachrichten
	if osc_receiver and osc_receiver.has_method("get"):
		var target_server = $OSCServer
		if target_server and target_server.incoming_messages.has(osc_receiver.osc_address):
			osc_value = target_server.incoming_messages[osc_receiver.osc_address][0]
			if osc_receiver.osc_address == "/data/motion/accelerometer/y":
				# Verarbeitung für Y-Wert
				print("Y-Wert empfangen: ", osc_value)
				# Hier Y-spezifische Logik hinzufügen
				paddle_position_y = osc_value
			if osc_receiver.osc_address == "/data/motion/accelerometer/x":
				# Verarbeitung für X-Wert
				print("X-Wert empfangen: ", osc_value)
				# Hier X-spezifische Logik hinzufügen, z.B. Paddle-Position aktualisieren
				paddle_position_x = osc_value
		
			target_server.incoming_messages.erase(osc_receiver.osc_address)

	# Skaliere den OSC-Wert auf den Bildschirmbereich
	# var normalized_value = -clamp(osc_value, -1, 1)  # Normalisiere den Wert auf [-1, 1]
	# var target_y = win_height / 2.0 + 2 * normalized_value * (win_height / 2.0 - p_height / 2.0)

	# Bewege das Paddle sanft Richtung Zielposition
	# position.y = lerp(float(position.y), float(target_y), delta * 5.0)  # "5.0" ist die Glättungsrate

	# Debugging-Ausgabe
	# print("Aktuelle Paddle-Position:", position.y, "Normalisierter Wert:", normalized_value)
