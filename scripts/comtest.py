import socket


def send_message_to_godot(message, ip="127.0.0.1", port=6000):
    try:
        # Socket erstellen
        udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

        # Nachricht an Godot senden
        udp_socket.sendto(message.encode("utf-8"), (ip, port))
        print(f"Message sent to {ip}:{port}: {message}")

    except Exception as e:
        print(f"An error occurred: {e}")

    finally:
        udp_socket.close()


if __name__ == "__main__":
    # Beispiel-Nachricht senden
    test_message = "42.0"  # Beispielwert für Gyro Y
    send_message_to_godot(test_message)
