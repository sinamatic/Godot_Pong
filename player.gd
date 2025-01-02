extends StaticBody2D

var win_height : int
var p_height : int
var osc_value : float = 0.0  # Initialer OSC-Wert

@onready var osc_receiver : Node = $OSCReceiver

func _ready():
	if osc_receiver:
		print("OSCReceiver gefunden:", osc_receiver)
		print("Zugehöriger Server:", osc_receiver.target_server)
		print("OSC-Adresse:", osc_receiver.osc_address)
	else:
		print("Kein OSCReceiver gefunden")

	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y

func _process(delta):
	if osc_receiver and osc_receiver.has_method("get"):
		var target_server = osc_receiver.target_server
		if target_server and target_server.incoming_messages.has(osc_receiver.osc_address):
			osc_value = target_server.incoming_messages[osc_receiver.osc_address][0]
			print("Empfangener OSC-Wert:", osc_value)
			target_server.incoming_messages.erase(osc_receiver.osc_address)

	# Bewege das Paddle
	if osc_value != 0:
		var movement = osc_value * delta * 500  # Teste mit fester Geschwindigkeit
		print("OSC-Wert für Bewegung:", osc_value)
		print("Berechnete Bewegung:", movement)

		position.y -= movement  # Abhängig von der Richtung des OSC-Werts

	# Begrenze die Paddle-Position
	position.y = clamp(position.y, p_height / 2, win_height - p_height / 2)

	# Debug-Ausgabe für Position
	print("Aktuelle Paddle-Position:", position.y)
