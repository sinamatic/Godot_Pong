from pythonosc import dispatcher
from pythonosc import osc_server
from pythonosc import udp_client


def p1_gyroscope_handler_y(address, *args):
    if args:  # Sicherstellen, dass args nicht leer ist
        value = float(
            args[0]
        )  # Extrahiere den ersten Wert und konvertiere ihn zu float
        print("p1: ", f"{address}: {value}")
        p1_godot_client.send_message("/data/motion/accelerometer/x", [value])


# changed x and y because now phone is in landscape mode
def p1_gyroscope_handler_x(address, *args):
    if args:  # Sicherstellen, dass args nicht leer ist
        value = float(
            args[0]
        )  # Extrahiere den ersten Wert und konvertiere ihn zu float
        print("p1: ", f"{address}: {value}")
        p1_godot_client.send_message("/data/motion/accelerometer/y", [value])


dispatcher = dispatcher.Dispatcher()
dispatcher.map("/data/motion/accelerometer/y", p1_gyroscope_handler_y)
dispatcher.map("/data/motion/accelerometer/x", p1_gyroscope_handler_x)

# Server configuration for receiving from the iPhone
p1_ip = "192.168.178.85"
p1_port = 5005

# Client configuration for sending to Godot
p1_godot_ip = "127.0.0.1"  # Replace with your Godot IP if necessary
p1_godot_port = 4646  # Replace with your Godot's receiving port

p1_godot_client = udp_client.SimpleUDPClient(p1_godot_ip, p1_godot_port)

p1_server = osc_server.BlockingOSCUDPServer((p1_ip, p1_port), dispatcher)
print(
    f"Listening on {p1_ip}:{p1_port} and forwarding to Godot {p1_godot_ip}:{p1_godot_port}"
)
p1_server.serve_forever()


###
# p2
###


def p2_gyroscope_handler_y(address, *args):
    if args:  # Sicherstellen, dass args nicht leer ist
        value = float(
            args[0]
        )  # Extrahiere den ersten Wert und konvertiere ihn zu float
        print("p2: ", f"{address}: {value}")
        p2_godot_client.send_message("/data/motion/accelerometer/x", [value])


# changed x and y because now phone is in landscape mode
def p2_gyroscope_handler_x(address, *args):
    if args:  # Sicherstellen, dass args nicht leer ist
        value = float(
            args[0]
        )  # Extrahiere den ersten Wert und konvertiere ihn zu float
        print("p2: ", f"{address}: {value}")
        p2_godot_client.send_message("/data/motion/accelerometer/y", [value])


dispatcher = dispatcher.Dispatcher()
dispatcher.map("/data/motion/accelerometer/y", p2_gyroscope_handler_y)
dispatcher.map("/data/motion/accelerometer/x", p2_gyroscope_handler_x)

# Server configuration for receiving from the iPhone
p2_ip = "192.168.178.85"
p2_port = 6006

# Client configuration for sending to Godot
p2_godot_ip = "127.0.0.1"  # Replace with your Godot IP if necessary
p2_godot_port = 4747  # Replace with your Godot's receiving port

p2_godot_client = udp_client.SimpleUDPClient(p2_godot_ip, p2_godot_port)

p2_server = osc_server.BlockingOSCUDPServer((p2_ip, p2_port), dispatcher)
print(
    f"Listening on {p2_ip}:{p2_port} and forwarding to Godot {p2_godot_ip}:{p2_godot_port}"
)
p2_server.serve_forever()
