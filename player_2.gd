extends StaticBody2D

var win_height: int
var p_height: int
var udp_server: UDPServer

# Called when the node enters the scene tree for the first time.
func _ready():
	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y

	# UDP-Server initialisieren
	udp_server = UDPServer.new()
	udp_server.listen(6000)  # Port muss mit Python-Skript und der OSC-App übereinstimmen
	print("Listening for OSC data on UDP port 6000")

func _process(delta):
	print("Checking for connections...")  # Debug-Ausgabe
	if udp_server.is_connection_available():
		print("Connection available!")  # Debug-Ausgabe
		var connection = udp_server.take_connection()
		if connection:
			print("Connection taken")  # Debug-Ausgabe
			var packet = connection.get_packet()
			if packet:
				var data = packet.get_string_from_utf8()
				print("Received packet data:", data)  # Debug-Ausgabe
				var gyro_y = float(data)
				print("Parsed Gyro Y:", gyro_y)  # Debug-Ausgabe
				update_paddle_position(gyro_y * 100.0)
			else:
				print("No packet data received")
	else:
		print("No connection available")  # Debug-Ausgabe


# Paddle-Position aktualisieren
func update_paddle_position(paddle_position):
	position.y = clamp(paddle_position, p_height / 2, win_height - p_height / 2)
