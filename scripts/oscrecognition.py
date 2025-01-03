from pythonosc import dispatcher
from pythonosc import osc_server
from pythonosc import udp_client


def gyroscope_handler_y(address, *args):
    if args:  # Sicherstellen, dass args nicht leer ist
        value = float(
            args[0]
        )  # Extrahiere den ersten Wert und konvertiere ihn zu float
        print(f"{address}: {value}")
        godot_client.send_message("/data/motion/accelerometer/y", [value])


def gyroscope_handler_x(address, *args):
    if args:  # Sicherstellen, dass args nicht leer ist
        value = float(
            args[0]
        )  # Extrahiere den ersten Wert und konvertiere ihn zu float
        print(f"{address}: {value}")
        godot_client.send_message("/data/motion/accelerometer/x", [value])


dispatcher = dispatcher.Dispatcher()
dispatcher.map("/data/motion/accelerometer/y", gyroscope_handler_y)
dispatcher.map("/data/motion/accelerometer/x", gyroscope_handler_x)

# Server configuration for receiving from the iPhone
ip = "192.168.178.85"
port = 5005

# Client configuration for sending to Godot
godot_ip = "127.0.0.1"  # Replace with your Godot IP if necessary
godot_port = 4646  # Replace with your Godot's receiving port

godot_client = udp_client.SimpleUDPClient(godot_ip, godot_port)

server = osc_server.BlockingOSCUDPServer((ip, port), dispatcher)
print(f"Listening on {ip}:{port} and forwarding to Godot {godot_ip}:{godot_port}")
server.serve_forever()
