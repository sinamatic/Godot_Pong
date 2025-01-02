from pythonosc import dispatcher
from pythonosc import osc_server


def gyroscope_handler(address, *args):
    print(f"{address}: {args}")


dispatcher = dispatcher.Dispatcher()
dispatcher.map("/data/motion/gyroscope/y", gyroscope_handler)

ip = "192.168.178.85"
port = 5005

server = osc_server.BlockingOSCUDPServer((ip, port), dispatcher)
print(f"Listening on {ip}:{port}")
server.serve_forever()
