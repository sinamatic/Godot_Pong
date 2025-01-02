from pythonosc import dispatcher
from pythonosc import osc_server
from pythonosc import udp_client


def gyroscope_handler(address, *args):
    print(f"{address}: {args}")
    godot_client.send_message("/data/motion/gyroscope/y", args)


dispatcher = dispatcher.Dispatcher()
dispatcher.map("/data/motion/gyroscope/y", gyroscope_handler)

# Server configuration for receiving from the iPhone
ip = "192.168.178.85"
port = 5005

# Client configuration for sending to Godot
godot_ip = "127.0.0.1"  # Replace with your Godot IP if necessary
godot_port = 6000  # Replace with your Godot's receiving port

godot_client = udp_client.SimpleUDPClient(godot_ip, godot_port)

server = osc_server.BlockingOSCUDPServer((ip, port), dispatcher)
print(f"Listening on {ip}:{port} and forwarding to Godot {godot_ip}:{godot_port}")
server.serve_forever()
