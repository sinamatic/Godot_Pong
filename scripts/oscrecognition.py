from pythonosc import dispatcher
from pythonosc import osc_server
from pythonosc import udp_client
import threading

# Branch Raphi


# Handler für iPhone 1
def p1_accelerometer_handler_y(address, *args):
    if args:  # Sicherstellen, dass args nicht leer ist
        value = float(args[0])
        print("p1: ", f"{address}: {value}")
        p1_godot_client.send_message("/data/motion/accelerometer/x", [value])


def p1_accelerometer_handler_x(address, *args):
    if args:  # Sicherstellen, dass args nicht leer ist
        value = float(args[0])
        print("p1: ", f"{address}: {value}")
        p1_godot_client.send_message("/data/motion/accelerometer/y", [value])


# Handler für iPhone 2
def p2_accelerometer_handler_y(address, *args):
    if args:  # Sicherstellen, dass args nicht leer ist
        value = float(args[0])
        print("p2: ", f"{address}: {value}")
        p2_godot_client.send_message("/data/motion/accelerometer/x", [value])


def p2_accelerometer_handler_x(address, *args):
    if args:  # Sicherstellen, dass args nicht leer ist
        value = float(args[0])
        print("p2: ", f"{address}: {value}")
        p2_godot_client.send_message("/data/motion/accelerometer/y", [value])


# Dispatcher und Server für iPhone 1
dispatcher1 = dispatcher.Dispatcher()
dispatcher1.map("/data/motion/accelerometer/y", p1_accelerometer_handler_y)
dispatcher1.map("/data/motion/accelerometer/x", p1_accelerometer_handler_x)

# Dispatcher und Server für iPhone 2
dispatcher2 = dispatcher.Dispatcher()
dispatcher2.map("/data/motion/accelerometer/y", p2_accelerometer_handler_y)
dispatcher2.map("/data/motion/accelerometer/x", p2_accelerometer_handler_x)

# Server- und Client-Konfiguration für iPhone 1
p1_ip = "192.168.178.100"
p1_port = 9000
p1_godot_ip = "127.0.0.1"
p1_godot_port = 4646
p1_godot_client = udp_client.SimpleUDPClient(p1_godot_ip, p1_godot_port)

# Server- und Client-Konfiguration für iPhone 2
p2_ip = "192.168.178.100"
p2_port = 6006
p2_godot_ip = "127.0.0.1"
p2_godot_port = 4747  # Ändern Sie den Port, wenn nötig
p2_godot_client = udp_client.SimpleUDPClient(p2_godot_ip, p2_godot_port)


# Funktion zum Starten eines Servers in einem separaten Thread
def start_server(ip, port, dispatcher):
    server = osc_server.BlockingOSCUDPServer((ip, port), dispatcher)
    print(f"Listening on {ip}:{port}")
    server.serve_forever()


# Server in separaten Threads starten
thread1 = threading.Thread(target=start_server, args=(p1_ip, p1_port, dispatcher1))
thread2 = threading.Thread(target=start_server, args=(p2_ip, p2_port, dispatcher2))

thread1.start()
thread2.start()

# Threads laufen lassen
thread1.join()
thread2.join()
