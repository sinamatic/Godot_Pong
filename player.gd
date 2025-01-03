extends StaticBody2D

var win_height : int
var p_height : int
var osc_value : float  # Aktueller OSC-Wert

@onready var osc_receiver : Node = $OSCReceiver

func _ready():
	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y

func _process(delta):
	# Überprüfe eingehende Nachrichten
	if osc_receiver and osc_receiver.has_method("get"):
		var target_server = $OSCServer
		if target_server and target_server.incoming_messages.has(osc_receiver.osc_address):
			osc_value = target_server.incoming_messages[osc_receiver.osc_address][0]
			target_server.incoming_messages.erase(osc_receiver.osc_address)

			# Skaliere den OSC-Wert auf den Bildschirmbereich
			var normalized_value = -clamp(osc_value, -1, 1)  # Normalisiere den Wert auf [-2, 2]
			var target_y = win_height / 2.0 + 2 * normalized_value * (win_height / 2.0 - p_height / 2.0)
			
			# Bewege das Paddle sanft Richtung Zielposition
			position.y = lerp(float(position.y), float(target_y), delta * 5.0)  # "5.0" ist die Glättungsrate

			# Debugging-Ausgabe
			print("Aktuelle Paddle-Position:", position.y, "Normalisierter Wert:", normalized_value)
