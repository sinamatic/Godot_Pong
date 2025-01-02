extends StaticBody2D

var win_height : int
var p_height : int
var osc_value : float  # Aktueller OSC-Wert

@onready var osc_receiver : Node = $OSCReceiver

func _ready():
# 	if osc_receiver:
# 		print("OSCReceiver gefunden:", osc_receiver)
# 		print("Zugehöriger Server:", osc_receiver.target_server)
# 		print("OSC-Adresse:", osc_receiver.osc_address)
# 	else:
# 		print("Kein OSCReceiver gefunden")

	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y

func _process(delta):

	# Überprüfe eingehende Nachrichten
	if osc_receiver and osc_receiver.has_method("get"):
		var target_server = $OSCServer
		if target_server and target_server.incoming_messages.has(osc_receiver.osc_address):
			osc_value = target_server.incoming_messages[osc_receiver.osc_address][0]
			target_server.incoming_messages.erase(osc_receiver.osc_address)
			
			# Skaliere den OSC-Wert in den Bereich [-100, 100]
		
		# Begrenze die Paddle-Position
		position.y = clamp(position.y, p_height / 2, win_height - p_height / 2)

		# Debugging-Ausgabe
		print("Aktuelle Paddle-Position:", position.y, "OSC-Wert x 1000000: ", (osc_value * 10000))
