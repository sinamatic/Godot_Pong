import argparse
from pythonosc import dispatcher as osc_dispatcher_module
from pythonosc import osc_server
from collections import deque
import socket

# Einstellungen
HISTORY_SIZE = 500
GYRO_FACTOR = 100.0  # Multiplikationsfaktor zur Darstellung der Bewegung
UDP_IP = "127.0.0.1"  # Godot läuft lokal
UDP_PORT = 6000  # Port für Godot

# Gyro-Werte speichern
gyro_x_values = deque(maxlen=HISTORY_SIZE)
gyro_y_values = deque(maxlen=HISTORY_SIZE)
gyro_z_values = deque(maxlen=HISTORY_SIZE)

# UDP-Socket einrichten
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)


def gyro_handler_y(unused_addr, gyro_value):
    gyro_y_values.append(gyro_value)
    print(f"Gyro Y: {gyro_value}")

    # Berechnung der Paddle-Position
    avg_y = sum(gyro_y_values) / len(gyro_y_values)
    paddle_position = avg_y * GYRO_FACTOR

    # Sende Paddle-Position an Godot
    message = str(paddle_position).encode("utf-8")
    print(f"Preparing to send: {message.decode()} to {UDP_IP}:{UDP_PORT}")
    sock.sendto(message, (UDP_IP, UDP_PORT))
    print(f"Sent to Godot: {message.decode()}")


def run_osc_server():
    """
    Startet den OSC-Server und verarbeitet eingehende Daten.
    """
    print("Starting OSC server...")

    parser = argparse.ArgumentParser()
    parser.add_argument("--ip", default="192.168.2.118", help="IP address to listen on")
    parser.add_argument("--port", type=int, default=5005, help="Port to listen on")
    args = parser.parse_args()

    # Dispatcher einrichten
    osc_dispatcher = osc_dispatcher_module.Dispatcher()
    osc_dispatcher.map("/data/motion/gyroscope/y", gyro_handler_y)

    # Server starten
    server = osc_server.ThreadingOSCUDPServer((args.ip, args.port), osc_dispatcher)
    print(f"OSC server running on {args.ip}:{args.port}")
    print("Waiting for data...")

    # Server blockiert hier, bis er beendet wird
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("Shutting down OSC server")
        server.shutdown()
        sock.close()  # UDP-Socket schließen


if __name__ == "__main__":
    run_osc_server()
